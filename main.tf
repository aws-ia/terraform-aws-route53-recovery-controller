locals {
  regions        = keys(var.cells_definition)
  primary_region = var.primary_cell_region == null ? data.aws_region.current.name : var.primary_cell_region
  # list of all services referenced in var.cells_definition with non-null arns
  service_list          = setintersection(compact(flatten([for _, cell_definition in var.cells_definition : [for service_name, arn in cell_definition : arn != null ? service_name : null]])))
  routing_controls_arns = [for k, v in aws_route53recoverycontrolconfig_routing_control.per_cell : v.arn]
}

# Readiness control

module "recovery_group" {
  source = "./modules/readiness_recovery_group"

  name               = var.name
  regions            = local.regions
  cells_definition   = var.cells_definition
  service_list       = local.service_list
  resource_type_name = var.resource_type_name
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
