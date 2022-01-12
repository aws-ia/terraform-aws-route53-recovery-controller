module "arc" {
  source = "../.."

  name                           = var.name
  cells_definition               = var.cells_definition
  create_routing_control_cluster = var.create_routing_control_cluster

  hosted_zone = var.hosted_zone
}
