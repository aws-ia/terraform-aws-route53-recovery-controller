module "arc" {
  source = "../.."

  name                           = "test"
  cells_definition               = var.cells_definition
  create_routing_control_cluster = true

  hosted_zone = {
    name         = "test.com."
  }
}
