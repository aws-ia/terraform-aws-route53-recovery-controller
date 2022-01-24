output "dynamodb-arn" {
  value = aws_dynamodb_table.global.arn
}

output "s3_bucket_region_1" {
  value = aws_s3_bucket.artifact_bucket_region_1
}

output "s3_bucket_region_2" {
  value = aws_s3_bucket.artifact_bucket_region_2
}


output "code_deploy" {
  value = aws_codedeploy_deployment_group.main
}

output "asg_primary" {
  value = module.app_primary.asg
}

output "asg_alternative" {
  value = module.app_alternative.asg
}

output "alb_primary" {
  value = module.app_primary.alb
}

output "alb_alternative" {
  value = module.app_alternative.alb
}

output "dynamodb" {
  value = aws_dynamodb_table.global
}

