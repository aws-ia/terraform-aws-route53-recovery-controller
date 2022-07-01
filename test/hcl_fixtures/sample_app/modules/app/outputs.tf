output "alb_address" {
  value       = aws_alb.alb.dns_name
  description = "fixutre output"
}

output "asg" {
  value       = aws_autoscaling_group.app_asg
  description = "fixutre output"
}

output "alb" {
  value       = aws_alb.alb
  description = "fixutre output"
}
