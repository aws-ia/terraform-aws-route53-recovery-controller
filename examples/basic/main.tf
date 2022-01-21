module "basic-recovery-controller-example" {
  source = "../.."

  name                    = var.name
  cells_definition        = var.cells_definition
  create_recovery_cluster = var.create_recovery_cluster

  hosted_zone = var.hosted_zone
}
