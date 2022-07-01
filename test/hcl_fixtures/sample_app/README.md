<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.68 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.68 |
| <a name="provider_aws.alternative"></a> [aws.alternative](#provider\_aws.alternative) | >= 3.68 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_alternative"></a> [app\_alternative](#module\_app\_alternative) | ./modules/app | n/a |
| <a name="module_app_primary"></a> [app\_primary](#module\_app\_primary) | ./modules/app | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codedeploy_app.app_region_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_app.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.deployment_group_region_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codedeploy_deployment_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codepipeline.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_dynamodb_table.global](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codedeploy_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.codebuild_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codedeploy_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codepipeline_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.app_source_code](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.artifact_bucket_region_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.artifact_bucket_region_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.app_source_code](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_public_access_block.app_source_code](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.s3_region_1_public_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.s3_region_2_public_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of cidrs to allow communication to your app. | `list(string)` | n/a | yes |
| <a name="input_alternative_region"></a> [alternative\_region](#input\_alternative\_region) | The Alternative AWS region to deploy app to. | `string` | `"us-west-2"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | test app variable | `string` | `"tic-tac-toe"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_alternative"></a> [alb\_alternative](#output\_alb\_alternative) | fixture output |
| <a name="output_alb_primary"></a> [alb\_primary](#output\_alb\_primary) | fixture output |
| <a name="output_asg_alternative"></a> [asg\_alternative](#output\_asg\_alternative) | fixture output |
| <a name="output_asg_primary"></a> [asg\_primary](#output\_asg\_primary) | fixture output |
| <a name="output_code_deploy"></a> [code\_deploy](#output\_code\_deploy) | fixture output |
| <a name="output_dynamodb_arn"></a> [dynamodb\_arn](#output\_dynamodb\_arn) | fixture output |
| <a name="output_pipeline_url"></a> [pipeline\_url](#output\_pipeline\_url) | fixture output |
| <a name="output_s3_bucket_region_1"></a> [s3\_bucket\_region\_1](#output\_s3\_bucket\_region\_1) | fixture output |
| <a name="output_s3_bucket_region_2"></a> [s3\_bucket\_region\_2](#output\_s3\_bucket\_region\_2) | fixture output |
<!-- END_TF_DOCS -->