# Amazon Route53 Application Recovery Controller module

[Amazon Route53 Application Recovery Controller (Route 53 ARC)](https://aws.amazon.com/blogs/aws/amazon-route-53-application-recovery-controller/) is a set of Route 53 features that help you build applications with high availability. Route 53 ARC can continuously monitor your application's ability to recover from failure and control recovery across multiple AWS Availability Zones, AWS Regions, and on-premises environments. This Terraform module contains both Route 53 ARC readiness and recovery-cluster resources. You can deploy only the readiness resources, or both. For more information about creating a resilience strategy with Route 53 ARC, see [Running recovery-oriented applications with Amazon Route 53 Application Recovery Controller, AWS CI/CD tools, and Terraform](https://aws.amazon.com/blogs/networking-and-content-delivery/running-recovery-oriented-applications-with-amazon-route-53-application-recovery-controller-aws-ci-cd-tools-and-terraform/).

## Usage

The primary configuration variable is `cells_definition` in `variables.tf`. With this variable, you specify the AWS resources per Region (the "recovery group") that you want Route 53 ARC to monitor.

### Deploy readiness resources only

The following `terraform.tvars` values create a recovery group with Regions `us-east-1` and `us-west-2`. Each Region cell contains AWS services `elasticloadbalancing`, `autoscaling`, `dynamodb`, and `ec2-volume` and their Amazon Resource Numbers (ARNs). This configuration provides a readiness check for each included service.

```terraform
name = "my-asg-elb-ddb-app"

cells_definition = {
  us-east-1 = {
    elasticloadbalancing = <arn>
    autoscaling          = <arn>
    dynamodb             = <arn>
    ec2-volume           = <arn>
  }
  us-west-2 = {
    elasticloadbalancing = <arn>
    autoscaling          = <arn>
    dynamodb             = <arn>
    ec2-volume           = <arn>
  }
}
```

### Deploy routing control cluster resources and Route 53 alias records

To define a managed Route 53 ARC cluster for your application, add the following Terraform variables.

```terraform
create_recovery_cluster = false

hosted_zone = {
  name         = "mycoolapp.com."
}
```
Currently, this module supports active/passive for applications across Regions. The active Region is determined by your `provider` block or by `var.primary_cell_region`. (See "Inputs", later in this document.)

The example shown previously configures the following:
* A recovery cluster with a single control panel.
* One routing control per Region.
* Safety rules. The default is one, but you can declare more than one.
* One Route 53 health check per routing control.
* Route 53 alias records for each load balancer for the domain specified.

## Adding a new service

You can contribute to this module by adding a new service. To do so, complete the following steps.

1. Add the service to the `var.resource_type_name` variable type definition.
2. Add the service key (from step 1) to the validation check for `var.cells_definition` in `variables.tf`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.68 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.ap-northeast-1"></a> [aws.ap-northeast-1](#provider\_aws.ap-northeast-1) | 3.71.0 |
| <a name="provider_aws.ap-northeast-2"></a> [aws.ap-northeast-2](#provider\_aws.ap-northeast-2) | 3.71.0 |
| <a name="provider_aws.ap-northeast-3"></a> [aws.ap-northeast-3](#provider\_aws.ap-northeast-3) | 3.71.0 |
| <a name="provider_aws.ap-south-1"></a> [aws.ap-south-1](#provider\_aws.ap-south-1) | 3.71.0 |
| <a name="provider_aws.ap-southeast-1"></a> [aws.ap-southeast-1](#provider\_aws.ap-southeast-1) | 3.71.0 |
| <a name="provider_aws.ap-southeast-2"></a> [aws.ap-southeast-2](#provider\_aws.ap-southeast-2) | 3.71.0 |
| <a name="provider_aws.ca-central-1"></a> [aws.ca-central-1](#provider\_aws.ca-central-1) | 3.71.0 |
| <a name="provider_aws.eu-central-1"></a> [aws.eu-central-1](#provider\_aws.eu-central-1) | 3.71.0 |
| <a name="provider_aws.eu-north-1"></a> [aws.eu-north-1](#provider\_aws.eu-north-1) | 3.71.0 |
| <a name="provider_aws.eu-west-1"></a> [aws.eu-west-1](#provider\_aws.eu-west-1) | 3.71.0 |
| <a name="provider_aws.eu-west-2"></a> [aws.eu-west-2](#provider\_aws.eu-west-2) | 3.71.0 |
| <a name="provider_aws.eu-west-3"></a> [aws.eu-west-3](#provider\_aws.eu-west-3) | 3.71.0 |
| <a name="provider_aws.sa-east-1"></a> [aws.sa-east-1](#provider\_aws.sa-east-1) | 3.71.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | 3.71.0 |
| <a name="provider_aws.us-east-2"></a> [aws.us-east-2](#provider\_aws.us-east-2) | 3.71.0 |
| <a name="provider_aws.us-west-1"></a> [aws.us-west-1](#provider\_aws.us-west-1) | 3.71.0 |
| <a name="provider_aws.us-west-2"></a> [aws.us-west-2](#provider\_aws.us-west-2) | 3.71.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_recovery_cluster"></a> [recovery\_cluster](#module\_recovery\_cluster) | ./modules/recovery_cluster | n/a |
| <a name="module_recovery_group"></a> [recovery\_group](#module\_recovery\_group) | ./modules/readiness_recovery_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb.ap_northeast_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.ap_northeast_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.ap_northeast_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.ap_south_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.ap_southeast_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.ap_southeast_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.ca_central_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.eu_central_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.eu_north_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.eu_west_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.eu_west_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.eu_west_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.sa_east_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.us_east_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.us_east_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.us_west_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |
| [aws_lb.us_west_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | Data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cells_definition"></a> [cells\_definition](#input\_cells\_definition) | Nested map in which the keys are Regions you want to enable. Keys refer to resource ARNs to enable. Enabled services are defined in `var.resource_type_name`. | `map(map(string))` | n/a | yes |
| <a name="input_create_recovery_cluster"></a> [create\_recovery\_cluster](#input\_create\_recovery\_cluster) | Creates the routing control cluster and associated resources. | `bool` | `false` | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | Route 53 hosted zone. If the `name` or `zone_id` is not passed, a search is performed using the values provided. Leave null to not create Route53 alias records. Required for load balancer functionality. | <pre>object({<br>    name         = optional(string)<br>    private_zone = optional(bool)<br>    vpc_id       = optional(number)<br>    tags         = optional(map(string))<br>    zone_id      = optional(string)<br>  })</pre> | <pre>{<br>  "name": null,<br>  "zone_id": null<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Resource prefix. | `string` | n/a | yes |
| <a name="input_primary_cell_region"></a> [primary\_cell\_region](#input\_primary\_cell\_region) | (Optional) Route 53 primary Region. If not specified, the default provider Region is used. | `string` | `null` | no |
| <a name="input_resource_type_name"></a> [resource\_type\_name](#input\_resource\_type\_name) | List of all service types you can pass and their associated resource set type. | `map(string)` | <pre>{<br>  "apigateway": "AWS::ApiGatewayV2::Api",<br>  "autoscaling": "AWS::AutoScaling::AutoScalingGroup",<br>  "cloudwatch": "AWS::CloudWatch::Alarm",<br>  "dynamodb": "AWS::DynamoDB::Table",<br>  "ec2-volume": "AWS::EC2::Volume",<br>  "ec2-vpc": "AWS::EC2::VPC",<br>  "ec2-vpn-cgw": "AWS::EC2::CustomerGateway",<br>  "ec2-vpn-conn": "AWS::EC2::VPNConnection",<br>  "ec2-vpn-gw": "AWS::EC2::VPNGateway",<br>  "elasticloadbalancing": "AWS::ElasticLoadBalancingV2::LoadBalancer",<br>  "kafka": "AWS::MSK::Cluster",<br>  "lambda": "AWS::Lambda::Function",<br>  "rds": "AWS::RDS::DBCluster",<br>  "route53": "AWS::Route53::HealthCheck",<br>  "sns": "AWS::SNS::Topic",<br>  "sqs": "AWS::SQS::Queue"<br>}</pre> | no |
| <a name="input_safety_rule_type"></a> [safety\_rule\_type](#input\_safety\_rule\_type) | Type of safety rules to create. Can only be `"assertion"` or `"gating"`. | `string` | `"assertion"` | no |
| <a name="input_safety_rules"></a> [safety\_rules](#input\_safety\_rules) | Configuration of the safety rules. Key is the name applied to the rule. | <pre>map(object({<br>    wait_period_ms = number<br>    inverted       = bool<br>    threshold      = number<br>    type           = string<br>    name_suffix    = string<br>  }))</pre> | <pre>{<br>  "MinCellsActive": {<br>    "inverted": false,<br>    "name_suffix": "MinCellsActive",<br>    "threshold": 1,<br>    "type": "ATLEAST",<br>    "wait_period_ms": 5000<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be added to readiness resources. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cells"></a> [cells](#output\_cells) | Cells per Region. |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | Cluster information. |
| <a name="output_control_panel"></a> [control\_panel](#output\_control\_panel) | Control panel information. |
| <a name="output_health_checks"></a> [health\_checks](#output\_health\_checks) | Health checks. |
| <a name="output_r53_aliases"></a> [r53\_aliases](#output\_r53\_aliases) | Route53 alias records, if created. |
| <a name="output_readiness_checks"></a> [readiness\_checks](#output\_readiness\_checks) | Readiness check for each resource set. |
| <a name="output_recovery_group"></a> [recovery\_group](#output\_recovery\_group) | Recovery group resource. |
| <a name="output_resource_sets"></a> [resource\_sets](#output\_resource\_sets) | Resource set for each service with ARN entries for each Region. |
| <a name="output_routing_controls"></a> [routing\_controls](#output\_routing\_controls) | Routing controls per cell. |
| <a name="output_safety_rules"></a> [safety\_rules](#output\_safety\_rules) | Safety rules. |
