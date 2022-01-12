output "cluster" {
  description = "Cluster info."
  value       = aws_route53recoverycontrolconfig_cluster.main
}

output "control_panel" {
  description = "Control Panel info."
  value       = aws_route53recoverycontrolconfig_control_panel.main
}

output "routing_controls" {
  description = "Routing Controls per Cell."
  value       = aws_route53recoverycontrolconfig_routing_control.per_cell
}

output "safety_rules" {
  description = "Safety Rules."
  value       = aws_route53recoverycontrolconfig_safety_rule.assertion_or_gating
}

output "health_checks" {
  description = "Health Checks."
  value       = aws_route53_health_check.main
}

output "r53_aliases" {
  description = "Route53 Alias Records, if created."
  value       = can(aws_route53_record.alias) ? aws_route53_record.alias : null
}
