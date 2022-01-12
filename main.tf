locals {
  regions = keys(var.cells_definition)
  # list of all services referenced in var.cells_definition with non-null arns
  service_list = setintersection(compact(flatten([for _, cell_definition in var.cells_definition : [for service_name, arn in cell_definition : arn != null ? service_name : null]])))
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

module "routing_control_cluster" {
  count  = var.create_routing_control_cluster ? 1 : 0
  source = "./modules/routing_control_cluster"

  name                         = var.name
  regions                      = local.regions
  create_safety_rule_assertion = var.create_safety_rule_assertion
  safety_rule_assertion        = var.safety_rule_assertion
  create_safety_rule_gating    = var.create_safety_rule_gating
  safety_rule_gating           = var.safety_rule_gating
  hosted_zone                  = var.hosted_zone
  lb_info                      = local.lb_info
  configure_lbs                = local.configure_lbs
  cells_definition             = var.cells_definition
  create_r53_records           = var.create_r53_records
  primary_cell_region          = var.primary_cell_region
}
