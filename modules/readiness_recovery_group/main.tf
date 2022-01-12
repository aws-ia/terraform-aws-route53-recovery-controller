locals {
  cell_arn_by_region = { for k, v in aws_route53recoveryreadiness_cell.per_region : k => v.arn }
}

resource "aws_route53recoveryreadiness_cell" "per_region" {
  for_each  = toset(var.regions)
  cell_name = "${var.name}-${each.value}"
  tags      = var.tags
}

resource "aws_route53recoveryreadiness_recovery_group" "all_regions" {
  recovery_group_name = var.name
  cells               = [for _, v in aws_route53recoveryreadiness_cell.per_region : v.arn]
  tags                = var.tags
}

# for service referenced in cells_defintion create a set with resources defined per region
resource "aws_route53recoveryreadiness_resource_set" "each_region_per_service" {
  for_each = toset(var.service_list)

  resource_set_name = "${var.name}-ResourceSet-${each.key}"
  resource_set_type = lookup(var.resource_type_name, each.key)
  tags              = var.tags

  dynamic "resources" {
    for_each = var.cells_definition
    content {
      resource_arn     = resources.value[each.key]
      readiness_scopes = [lookup(local.cell_arn_by_region, resources.key, null)]
    }
  }
}

resource "aws_route53recoveryreadiness_readiness_check" "per_service" {
  for_each = toset(var.service_list)

  readiness_check_name = "${var.name}-ReadinessCheck-${each.key}"
  resource_set_name    = aws_route53recoveryreadiness_resource_set.each_region_per_service[each.key].resource_set_name
  tags                 = var.tags
}
