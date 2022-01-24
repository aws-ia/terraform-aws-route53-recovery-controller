locals {
  regions = keys(var.cells_definition)
  # list of all services referenced in var.cells_definition
  service_list = setintersection(compact(flatten([for _, cell_definition in var.cells_definition : [for service_name, arn in cell_definition : service_name]])))
}

# Readiness control
module "recovery_group" {
  source = "./modules/readiness_recovery_group"

  name               = var.name
  regions            = local.regions
  cells_definition   = var.cells_definition
  service_list       = local.service_list
  resource_type_name = var.resource_type_name
  tags               = var.tags
}

## Routing Control
module "recovery_cluster" {
  count  = var.create_recovery_cluster ? 1 : 0
  source = "./modules/recovery_cluster"

  name                = var.name
  regions             = local.regions
  safety_rule_type    = var.safety_rule_type
  safety_rules        = var.safety_rules
  hosted_zone         = var.hosted_zone
  lb_info             = local.lb_info
  cells_definition    = var.cells_definition
  primary_cell_region = var.primary_cell_region
}
