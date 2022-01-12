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

output "cluster" {
  description = "Cluster info."
  value       = can(module.recovery_cluster.cluster) ? module.recovery_cluster.cluster : null
}

output "control_panel" {
  description = "Control Panel info."
  value       = can(module.recovery_cluster.control_panel) ? module.recovery_cluster.control_panel : null
}

output "routing_controls" {
  description = "Routing Controls per Cell."
  value       = can(module.recovery_cluster.routing_controls) ? module.recovery_cluster.routing_controls : null
}

output "safety_rules" {
  description = "Safety Rules."
  value       = can(module.recovery_cluster.safety_rules) ? module.recovery_cluster.safety_rules : null
}

output "health_checks" {
  description = "Health Checks."
  value       = can(module.recovery_cluster.health_checks) ? module.recovery_cluster.health_checks : null
}

output "r53_aliases" {
  description = "Route53 Alias Records, if created."
  value       = can(module.recovery_cluster.r53_aliases) ? module.recovery_cluster.r53_aliases : null
}
