<!-- BEGIN_TF_DOCS -->
# Sample App Deployment with Route53 Application Recovery Controller

This is as example of adding ARC support to an app deployed using Regions as its Cell boundaries. Each Cell (Region) contains a replica of the application stack which includes an Application Load Balancer (ALB), EC2 Auto-Scaling Group (ASG), and DynamoDB.

The `main.tf` contains the application stack HCL but it is commented out because it is *only an example*. The sample app design was adapted from [this blog post](https://aws.amazon.com/blogs/networking-and-content-delivery/running-recovery-oriented-applications-with-amazon-route-53-application-recovery-controller-aws-ci-cd-tools-and-terraform/).

```bash
terraform init
# determine which cidr to allow access to your ALBs
terraform apply -var 'allowed_ips=["1.2.3.4/32"]'
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.68 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_basic_recovery_controller_example"></a> [basic\_recovery\_controller\_example](#module\_basic\_recovery\_controller\_example) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ips"></a> [allowed\_ips](#input\_allowed\_ips) | List of cidrs to allow communication to your app. | `list(string)` | n/a | yes |
| <a name="input_alternative_app_arns"></a> [alternative\_app\_arns](#input\_alternative\_app\_arns) | Outputs passed to module for testing purposes (/test/example\_basic\_test.go) | `any` | n/a | yes |
| <a name="input_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#input\_dynamodb\_table\_arn) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_primary_app_arns"></a> [primary\_app\_arns](#input\_primary\_app\_arns) | Outputs passed to module for testing purposes (/test/example\_basic\_test.go) | `any` | n/a | yes |
| <a name="input_cells_definition"></a> [cells\_definition](#input\_cells\_definition) | Definition of the resources that makeup your Cell that you want monitored by ARC. | `map(map(string))` | `null` | no |
| <a name="input_create_recovery_cluster"></a> [create\_recovery\_cluster](#input\_create\_recovery\_cluster) | Create the Routing Control Cluster and associated resources. | `bool` | `false` | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided. Leave null to not create Route53 Alias records (required for LB functionality) . | <pre>object({<br>    name         = optional(string)<br>    private_zone = optional(bool)<br>    vpc_id       = optional(number)<br>    tags         = optional(map(string))<br>    zone_id      = optional(string)<br>  })</pre> | <pre>{<br>  "name": null,<br>  "zone_id": null<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of your application. | `string` | `"test"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->