output "dynamodb_arn" {
  value       = aws_dynamodb_table.global.arn
  description = "fixture output"
}

output "s3_bucket_region_1" {
  value       = aws_s3_bucket.artifact_bucket_region_1
  description = "fixture output"
}

output "s3_bucket_region_2" {
  value       = aws_s3_bucket.artifact_bucket_region_2
  description = "fixture output"
}


output "code_deploy" {
  value       = aws_codedeploy_deployment_group.main
  description = "fixture output"
}

output "asg_primary" {
  value       = module.app_primary.asg.arn
  description = "fixture output"
}

output "asg_alternative" {
  value       = module.app_alternative.asg.arn
  description = "fixture output"
}

output "alb_primary" {
  value       = module.app_primary.alb.arn
  description = "fixture output"
}

output "alb_alternative" {
  value       = module.app_alternative.alb.arn
  description = "fixture output"
}

output "pipeline_url" {
  value       = "https://console.aws.amazon.com/codepipeline/home?region=${data.aws_region.current.name}#/view/${aws_codepipeline.pipeline.id}"
  description = "fixture output"
}

