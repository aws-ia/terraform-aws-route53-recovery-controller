locals {
  regions        = keys(var.cells_definition)
  primary_region = var.primary_cell_region == null ? data.aws_region.current.name : var.primary_cell_region
  # list of all services referenced in var.cells_definition with non-null arns
  service_list          = setintersection(flatten([for _, cell_definition in var.cells_definition : [for service_name, arn in cell_definition : arn != null ? service_name : null]]))
  routing_controls_arns = [for k, v in aws_route53recoverycontrolconfig_routing_control.per_cell : v.arn]
  zone_id               = try(data.aws_route53_zone.main[0].zone_id, var.hosted_zone.zone_id)
  domain_name           = try(data.aws_route53_zone.main[0].name, var.hosted_zone.name)
  cell_arn_by_region    = { for k, v in aws_route53recoveryreadiness_cell.per_region : k => v.arn }
  # Optionals
  # aws_dynamodb_global_table only provides a single region arn, contruct all global table arns
  global_table_arns = try({ for region in local.regions : region => replace(var.global_table_arn, split(":", var.global_table_arn)[3], region) }, null)

  configure_lbs  = contains(local.service_list, "elasticloadbalancing")
  configure_lambdas  = false # contains(local.service_list, "lambda")
  configure_asgs = contains(local.service_list, "autoscaling")
  configure_ddb  = var.global_table_arn != null ? true : false

  resource_type_name = {
    elasticloadbalancing = "AWS::ElasticLoadBalancingV2::LoadBalancer"
    autoscaling          = "AWS::AutoScaling::AutoScalingGroup"
    lambda               = "AWS::Lambda::Function"
    dynamodb             = "AWS::DynamoDB::Table"
  }
}

# Readiness controls

resource "aws_route53recoveryreadiness_cell" "per_region" {
  for_each  = toset(local.regions)
  cell_name = "${var.name}-${each.value}"
}

resource "aws_route53recoveryreadiness_recovery_group" "all_regions" {
  recovery_group_name = var.name
  cells               = [for _, v in aws_route53recoveryreadiness_cell.per_region : v.arn]
}

resource "aws_route53recoveryreadiness_resource_set" "elasticloadbalancing" {
  count = local.configure_lbs ? 1 : 0

  resource_set_name = "${var.name}-ResourceSet-lb"
  resource_set_type = lookup(local.resource_type_name, "elasticloadbalancing")

  dynamic "resources" {
    for_each = var.cells_definition
    content {
      resource_arn     = resources.value.elasticloadbalancing
      readiness_scopes = [lookup(local.cell_arn_by_region, resources.key, null)]
    }
  }
}

resource "aws_route53recoveryreadiness_resource_set" "autoscaling" {
  count = local.configure_asgs ? 1 : 0

  resource_set_name = "${var.name}-ResourceSet-ASG"
  resource_set_type = lookup(local.resource_type_name, "autoscaling")

  dynamic "resources" {
    for_each = var.cells_definition
    content {
      resource_arn     = resources.value.autoscaling
      readiness_scopes = [lookup(local.cell_arn_by_region, resources.key, null)]
    }
  }
}

resource "aws_route53recoveryreadiness_resource_set" "lambda" {
  count = local.configure_lambdas ? 1 : 0

  resource_set_name = "${var.name}-ResourceSet-lambda"
  resource_set_type = lookup(local.resource_type_name, "lambda")

  dynamic "resources" {
    for_each = var.cells_definition
    content {
      resource_arn     = resources.value.lambda
      readiness_scopes = [lookup(local.cell_arn_by_region, resources.key, null)]
    }
  }
}

resource "aws_route53recoveryreadiness_resource_set" "dynamodb" {
  count = local.configure_ddb ? 1 : 0

  resource_set_name = "${var.name}-ResourceSet-DDB"
  resource_set_type = lookup(local.resource_type_name, "dynamodb")

  dynamic "resources" {
    for_each = local.global_table_arns
    content {
      resource_arn     = resources.value
      readiness_scopes = [lookup(local.cell_arn_by_region, resources.key, null)]
    }
  }
}

resource "aws_route53recoveryreadiness_readiness_check" "elasticloadbalancing" {
  count = local.configure_lbs ? 1 : 0

  readiness_check_name = "${var.name}-ReadinessCheck-lb"
  resource_set_name    = aws_route53recoveryreadiness_resource_set.elasticloadbalancing[0].resource_set_name
}

resource "aws_route53recoveryreadiness_readiness_check" "autoscaling" {
  count                = local.configure_asgs ? 1 : 0
  readiness_check_name = "${var.name}-ReadinessCheck-ASG"
  resource_set_name    = aws_route53recoveryreadiness_resource_set.autoscaling[0].resource_set_name
}

resource "aws_route53recoveryreadiness_readiness_check" "lambda" {
  count = local.configure_lambdas ? 1 : 0

  readiness_check_name = "${var.name}-ReadinessCheck-lambda"
  resource_set_name    = aws_route53recoveryreadiness_resource_set.lambda[0].resource_set_name
}

resource "aws_route53recoveryreadiness_readiness_check" "dynamodb" {
  count = local.configure_ddb ? 1 : 0

  readiness_check_name = "${var.name}-ReadinessCheck-DynamoDB"
  resource_set_name    = aws_route53recoveryreadiness_resource_set.dynamodb[0].resource_set_name
}

## Routing Control

resource "aws_route53recoverycontrolconfig_cluster" "main" {
  name = "${var.name}-Cluster"
}

resource "aws_route53recoverycontrolconfig_control_panel" "main" {
  name        = "${var.name}-ControlPanel"
  cluster_arn = aws_route53recoverycontrolconfig_cluster.main.arn
}

resource "aws_route53recoverycontrolconfig_routing_control" "per_cell" {
  for_each = toset(local.regions)

  name              = "${var.name}-${each.value}"
  cluster_arn       = aws_route53recoverycontrolconfig_cluster.main.arn
  control_panel_arn = aws_route53recoverycontrolconfig_control_panel.main.arn
}

resource "aws_route53recoverycontrolconfig_safety_rule" "assertion" {
  count = var.create_safety_rule_assertion ? 1 : 0

  asserted_controls = local.routing_controls_arns
  control_panel_arn = aws_route53recoverycontrolconfig_control_panel.main.arn
  name              = "${var.name}-${var.safety_rule_assertion.name_suffix}"
  wait_period_ms    = var.safety_rule_assertion.wait_period_ms

  rule_config {
    inverted  = var.safety_rule_assertion.inverted
    threshold = var.safety_rule_assertion.threshold
    type      = var.safety_rule_assertion.type
  }
}

resource "aws_route53recoverycontrolconfig_safety_rule" "gating" {
  count = var.create_safety_rule_gating ? 1 : 0

  gating_controls   = local.routing_controls_arns
  control_panel_arn = aws_route53recoverycontrolconfig_control_panel.main.arn
  name              = "${var.name}-${var.safety_rule_gating.name_suffix}"
  wait_period_ms    = var.safety_rule_gating.wait_period_ms

  rule_config {
    inverted  = var.safety_rule_gating.inverted
    threshold = var.safety_rule_gating.threshold
    type      = var.safety_rule_gating.type
  }
}

resource "aws_route53_health_check" "main" {
  for_each = aws_route53recoverycontrolconfig_routing_control.per_cell

  routing_control_arn = each.value.arn
  type                = "RECOVERY_CONTROL"
}

resource "aws_route53_record" "alias" {
  for_each = var.configure_route53_alias_records && local.configure_lbs ? var.cells_definition : {}

  zone_id = local.zone_id
  name    = "${var.name}.${local.domain_name}"
  type    = "A"
  alias {
    name                   = lookup(local.lb_info, each.key, null).dns_name
    zone_id                = lookup(local.lb_info, each.key, null).zone_id
    evaluate_target_health = true
  }
  set_identifier = "${var.name}-${each.key}"
  failover_routing_policy {
    type = each.key == local.primary_region ? "PRIMARY" : "SECONDARY"
  }

  health_check_id = lookup(aws_route53_health_check.main, each.key, null).id
}
