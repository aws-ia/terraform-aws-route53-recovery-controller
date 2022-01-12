data "aws_region" "current" {}

// if zone_id and name are not passed, do not create route53 resources
data "aws_route53_zone" "main" {
  count = var.hosted_zone.zone_id != null || var.hosted_zone.name != null ? 1 : 0

  name         = var.hosted_zone.name
  private_zone = var.hosted_zone.private_zone
  vpc_id       = var.hosted_zone.vpc_id
  tags         = var.hosted_zone.tags
}

locals {
  routing_controls_arns = [for k, v in aws_route53recoverycontrolconfig_routing_control.per_cell : v.arn]
  primary_region        = var.primary_cell_region == null ? data.aws_region.current.name : var.primary_cell_region
}

resource "aws_route53recoverycontrolconfig_cluster" "main" {
  name = "${var.name}-Cluster"
}

resource "aws_route53recoverycontrolconfig_control_panel" "main" {
  name        = "${var.name}-ControlPanel"
  cluster_arn = aws_route53recoverycontrolconfig_cluster.main.arn
}

resource "aws_route53recoverycontrolconfig_routing_control" "per_cell" {
  for_each = toset(var.regions)

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

// if zone_id and name are not passed, do not create route53 resources
resource "aws_route53_record" "alias" {
  for_each = can(data.aws_route53_zone.main[0].zone_id) ? var.cells_definition : {}

  zone_id = data.aws_route53_zone.main[0].zone_id
  name    = "${var.name}.${data.aws_route53_zone.main[0].name}"
  type    = "A"
  alias {
    name                   = lookup(var.lb_info, each.key, null).dns_name
    zone_id                = lookup(var.lb_info, each.key, null).zone_id
    evaluate_target_health = true
  }
  set_identifier = "${var.name}-${each.key}"
  failover_routing_policy {
    type = each.key == local.primary_region ? "PRIMARY" : "SECONDARY"
  }

  health_check_id = lookup(aws_route53_health_check.main, each.key, null).id
}
