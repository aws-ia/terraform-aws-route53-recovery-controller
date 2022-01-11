output "recovery_group" {
  description = "Recovery Group resource."
  value       = aws_route53recoveryreadiness_recovery_group.all_regions
}

output "cells" {
  description = "Cells per region."
  value       = aws_route53recoveryreadiness_cell.per_region
}

output "resource_sets" {
  description = "A Resource Set for each service with ARN entries for each region."
  value       = aws_route53recoveryreadiness_resource_set.each_region_per_service
}

output "readiness_checks" {
  description = "A Readiness Check for each Resource Set"
  value       = aws_route53recoveryreadiness_readiness_check.per_service
}
