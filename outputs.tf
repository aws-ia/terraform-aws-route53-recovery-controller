output "recovery_group" {
  description = "Recovery group resource."
  value       = module.recovery_group.recovery_group
}

output "cells" {
  description = "Cells per Region."
  value       = module.recovery_group.cells
}

output "resource_sets" {
  description = "A Resource set for each service with ARN entries for each Region."
  value       = module.recovery_group.resource_sets
}

output "readiness_checks" {
  description = "A Readiness check for each resource set."
  value       = module.recovery_group.readiness_checks
}

output "cluster" {
  description = "Cluster information."
  value       = can(module.recovery_cluster[0].cluster) ? module.recovery_cluster[0].cluster : null
}

output "control_panel" {
  description = "Control Panel information."
  value       = can(module.recovery_cluster[0].control_panel) ? module.recovery_cluster[0].control_panel : null
}

output "routing_controls" {
  description = "Routing controls per cell."
  value       = can(module.recovery_cluster[0].routing_controls) ? module.recovery_cluster[0].routing_controls : null
}

output "safety_rules" {
  description = "Safety rules."
  value       = can(module.recovery_cluster[0].safety_rules) ? module.recovery_cluster[0].safety_rules : null
}

output "health_checks" {
  description = "Health checks."
  value       = can(module.recovery_cluster[0].health_checks) ? module.recovery_cluster[0].health_checks : null
}

output "r53_aliases" {
  description = "Route53 alias records, if created."
  value       = can(module.recovery_cluster[0].r53_aliases) ? module.recovery_cluster[0].r53_aliases : null
}
