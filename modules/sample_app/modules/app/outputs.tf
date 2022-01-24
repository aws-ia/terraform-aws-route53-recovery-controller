output "alb_address" {
  value = aws_alb.alb.dns_name
}

output "asg" {
  value = aws_autoscaling_group.app_asg
}

output "alb" {
  value = aws_alb.alb
}
