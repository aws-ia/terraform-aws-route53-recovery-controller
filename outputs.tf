output "recovery_group" {
  description = "Recovery Group resource."
  value       = module.recovery_group.recovery_group
}

output "cells" {
  description = "Cells per region."
  value       = module.recovery_group.cells
}

output "resource_sets" {
  description = "A Resource Set for each service with ARN entries for each region."
  value       = module.recovery_group.resource_sets
}

output "readiness_checks" {
  description = "A Readiness Check for each Resource Set"
  value       = module.recovery_group.readiness_checks
}
