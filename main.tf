locals {
  regions = keys(var.cell_attributes)
  cell_arn_by_region = {for k, v in aws_route53recoveryreadiness_cell.per_region : k => v.arn}

  # Optionals
  # aws_dynamodb_global_table only provides a single region arn, contruct all global table arns
  global_table_arns = try({for region in local.regions : region => replace(var.global_table_arn, split(":", var.global_table_arn)[3], region)}, null)

  config_lbs = var.cell_attributes[local.regions[0]].lb != null ? true : false
  config_asgs = var.cell_attributes[local.regions[0]].asg != null ? true : false
  config_ddb = var.global_table_arn != null ? true : false
}

resource "aws_route53recoveryreadiness_cell" "per_region" {
  for_each = toset(local.regions)
  cell_name = "${var.name}-${each.value}"
}

resource "aws_route53recoveryreadiness_recovery_group" "all_regions" {
  recovery_group_name = var.name
  cells               = [for _, v in aws_route53recoveryreadiness_cell.per_region : v.arn]
}

resource "aws_route53recoveryreadiness_resource_set" "lbs" {
  count = local.config_lbs ? 1 : 0

  resource_set_name = "${var.name}-ResourceSet-lb"
  resource_set_type = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  dynamic resources {
    for_each = var.cell_attributes
    content {
      resource_arn     = resources.value.lb
      readiness_scopes = [lookup(local.cell_arn_by_region, resources.key, null)]
    }
  }
}

resource "aws_route53recoveryreadiness_resource_set" "asgs" {
  count = local.config_asgs ? 1 : 0

  resource_set_name = "${var.name}-ResourceSet-ASG"
  resource_set_type = "AWS::AutoScaling::AutoScalingGroup"

  dynamic resources {
    for_each = var.cell_attributes
    content {
      resource_arn     = resources.value.asg
      readiness_scopes = [lookup(local.cell_arn_by_region, resources.key, null)]
    }
  }
}

resource "aws_route53recoveryreadiness_resource_set" "ddbs" {
  count = local.config_ddb ? 1 : 0

  resource_set_name = "${var.name}-ResourceSet-DDB"
  resource_set_type = "AWS::DynamoDB::Table"

  dynamic resources {
    for_each = local.global_table_arns
    content {
      resource_arn     = resources.value
      readiness_scopes = [lookup(local.cell_arn_by_region, resources.key, null)]
    }
  }
}


## implement check and condition
resource "aws_route53recoveryreadiness_readiness_check" "lb" {
  count = local.config_lbs ? 1 : 0

  readiness_check_name = "${var.name}-ReadinessCheck-lb"
  resource_set_name    = aws_route53recoveryreadiness_resource_set.lbs[0].resource_set_name
}

resource "aws_route53recoveryreadiness_readiness_check" "asg" {
  count = local.config_asgs ? 1 : 0
  readiness_check_name = "${var.name}-ReadinessCheck-ASG"
  resource_set_name    = aws_route53recoveryreadiness_resource_set.asgs[0].resource_set_name
}

resource "aws_route53recoveryreadiness_readiness_check" "ddb" {
  count = local.config_ddb ? 1 : 0

  readiness_check_name = "${var.name}-ReadinessCheck-DynamoDB"
  resource_set_name    = aws_route53recoveryreadiness_resource_set.ddbs[0].resource_set_name
}

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

resource "aws_route53recoverycontrolconfig_safety_rule" "main" {
  asserted_controls = [for k, v in aws_route53recoverycontrolconfig_routing_control.per_cell : v.arn]
  control_panel_arn = aws_route53recoverycontrolconfig_control_panel.main.arn
  name              = "${var.name}-MinCellsActive"
  wait_period_ms    = 5000

  rule_config {
    inverted  = false
    threshold = 1
    type      = "ATLEAST"
  }
}

resource "aws_route53_health_check" "main" {
  for_each = aws_route53recoverycontrolconfig_routing_control.per_cell

  routing_control_arn = each.value.arn
  type                = "RECOVERY_CONTROL"
}
