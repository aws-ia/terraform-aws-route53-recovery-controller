> Note: This module is in alpha state and is likely to contain bugs and updates may introduce breaking changes. It is not recommended for production use at this time.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.68 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | ~> 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.70.0 |
| <a name="provider_aws.ap-northeast-1"></a> [aws.ap-northeast-1](#provider\_aws.ap-northeast-1) | 3.70.0 |
| <a name="provider_aws.ap-northeast-2"></a> [aws.ap-northeast-2](#provider\_aws.ap-northeast-2) | 3.70.0 |
| <a name="provider_aws.ap-northeast-3"></a> [aws.ap-northeast-3](#provider\_aws.ap-northeast-3) | 3.70.0 |
| <a name="provider_aws.ap-south-1"></a> [aws.ap-south-1](#provider\_aws.ap-south-1) | 3.70.0 |
| <a name="provider_aws.ap-southeast-1"></a> [aws.ap-southeast-1](#provider\_aws.ap-southeast-1) | 3.70.0 |
| <a name="provider_aws.ap-southeast-2"></a> [aws.ap-southeast-2](#provider\_aws.ap-southeast-2) | 3.70.0 |
| <a name="provider_aws.ca-central-1"></a> [aws.ca-central-1](#provider\_aws.ca-central-1) | 3.70.0 |
| <a name="provider_aws.eu-central-1"></a> [aws.eu-central-1](#provider\_aws.eu-central-1) | 3.70.0 |
| <a name="provider_aws.eu-north-1"></a> [aws.eu-north-1](#provider\_aws.eu-north-1) | 3.70.0 |
| <a name="provider_aws.eu-west-1"></a> [aws.eu-west-1](#provider\_aws.eu-west-1) | 3.70.0 |
| <a name="provider_aws.eu-west-2"></a> [aws.eu-west-2](#provider\_aws.eu-west-2) | 3.70.0 |
| <a name="provider_aws.eu-west-3"></a> [aws.eu-west-3](#provider\_aws.eu-west-3) | 3.70.0 |
| <a name="provider_aws.sa-east-1"></a> [aws.sa-east-1](#provider\_aws.sa-east-1) | 3.70.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | 3.70.0 |
| <a name="provider_aws.us-east-2"></a> [aws.us-east-2](#provider\_aws.us-east-2) | 3.70.0 |
| <a name="provider_aws.us-west-1"></a> [aws.us-west-1](#provider\_aws.us-west-1) | 3.70.0 |
| <a name="provider_aws.us-west-2"></a> [aws.us-west-2](#provider\_aws.us-west-2) | 3.70.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_health_check.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53recoverycontrolconfig_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_cluster) | resource |
| [aws_route53recoverycontrolconfig_control_panel.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_control_panel) | resource |
| [aws_route53recoverycontrolconfig_routing_control.per_cell](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_routing_control) | resource |
| [aws_route53recoverycontrolconfig_safety_rule.assertion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_safety_rule) | resource |
| [aws_route53recoverycontrolconfig_safety_rule.gating](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_safety_rule) | resource |
| [aws_route53recoveryreadiness_cell.per_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_cell) | resource |
| [aws_route53recoveryreadiness_readiness_check.autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_readiness_check) | resource |
| [aws_route53recoveryreadiness_readiness_check.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_readiness_check) | resource |
| [aws_route53recoveryreadiness_readiness_check.elasticloadbalancing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_readiness_check) | resource |
| [aws_route53recoveryreadiness_recovery_group.all_regions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_recovery_group) | resource |
| [aws_route53recoveryreadiness_resource_set.autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_resource_set) | resource |
| [aws_route53recoveryreadiness_resource_set.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_resource_set) | resource |
| [aws_route53recoveryreadiness_resource_set.elasticloadbalancing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_resource_set) | resource |
| [aws_lb.ap_northeast_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_northeast_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_northeast_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_south_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_southeast_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_southeast_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ca_central_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_central_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_north_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_west_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_west_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_west_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.sa_east_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.us_east_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.us_east_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.us_west_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.us_west_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cell_attributes"></a> [cell\_attributes](#input\_cell\_attributes) | Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled: `elasticloadbalancing`, `autoscaling`. Example below: | <pre>map(object({<br>    elasticloadbalancing = optional(string)<br>    autoscaling          = optional(string)<br>    dynamodb             = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_create_safety_rule_assertion"></a> [create\_safety\_rule\_assertion](#input\_create\_safety\_rule\_assertion) | Whether or not to create an Assertion Saftey Rule | `bool` | `true` | no |
| <a name="input_create_safety_rule_gating"></a> [create\_safety\_rule\_gating](#input\_create\_safety\_rule\_gating) | Whether or not to create an Gating Saftey Rule | `bool` | `false` | no |
| <a name="input_global_table_arn"></a> [global\_table\_arn](#input\_global\_table\_arn) | Dyanmodb Global Table if being used. Only need to pass for 1 region, will parse other region table arns. | `string` | `null` | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided. | <pre>object({<br>    name         = optional(string)<br>    private_zone = optional(bool)<br>    vpc_id       = optional(number)<br>    tags         = optional(map(string))<br>    zone_id      = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to prefix resources. | `string` | n/a | yes |
| <a name="input_primary_cell_region"></a> [primary\_cell\_region](#input\_primary\_cell\_region) | (Optional) Region name of which Cell to make Route53 Primary. Defaults to default provider region if not set. | `string` | `null` | no |
| <a name="input_safety_rule_assertion"></a> [safety\_rule\_assertion](#input\_safety\_rule\_assertion) | Configuration of the Assertion Safety Rule | <pre>object({<br>    wait_period_ms = number<br>    inverted       = bool<br>    threshold      = number<br>    type           = string<br>    name_suffix    = string<br>  })</pre> | <pre>{<br>  "inverted": false,<br>  "name_suffix": "MinCellsActive",<br>  "threshold": 1,<br>  "type": "ATLEAST",<br>  "wait_period_ms": 5000<br>}</pre> | no |
| <a name="input_safety_rule_gating"></a> [safety\_rule\_gating](#input\_safety\_rule\_gating) | Configuration of the Gating Safety Rule | <pre>object({<br>    wait_period_ms = number<br>    inverted       = bool<br>    threshold      = number<br>    type           = string<br>    name_suffix    = string<br>  })</pre> | `null` | no |

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
> Note: This module is in alpha state and is likely to contain bugs and updates may introduce breaking changes. It is not recommended for production use at this time.

### Adding a new service

1. add to `cell_attributes` variable type definition
1. `aws_route53recoveryreadiness_resource_set`
1. `aws_route53recoveryreadiness_readiness_check`
1. create bool for conditional checks. aka. `config_lbs`

### Interpolating all dynamodb arns

global\_table\_arns = try({ for region in var.regions : region => replace(var.global\_table\_arn, split(":", var.global\_table\_arn)[3], region) }, null)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.68 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | ~> 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.ap-northeast-1"></a> [aws.ap-northeast-1](#provider\_aws.ap-northeast-1) | 3.70.0 |
| <a name="provider_aws.ap-northeast-2"></a> [aws.ap-northeast-2](#provider\_aws.ap-northeast-2) | 3.70.0 |
| <a name="provider_aws.ap-northeast-3"></a> [aws.ap-northeast-3](#provider\_aws.ap-northeast-3) | 3.70.0 |
| <a name="provider_aws.ap-south-1"></a> [aws.ap-south-1](#provider\_aws.ap-south-1) | 3.70.0 |
| <a name="provider_aws.ap-southeast-1"></a> [aws.ap-southeast-1](#provider\_aws.ap-southeast-1) | 3.70.0 |
| <a name="provider_aws.ap-southeast-2"></a> [aws.ap-southeast-2](#provider\_aws.ap-southeast-2) | 3.70.0 |
| <a name="provider_aws.ca-central-1"></a> [aws.ca-central-1](#provider\_aws.ca-central-1) | 3.70.0 |
| <a name="provider_aws.eu-central-1"></a> [aws.eu-central-1](#provider\_aws.eu-central-1) | 3.70.0 |
| <a name="provider_aws.eu-north-1"></a> [aws.eu-north-1](#provider\_aws.eu-north-1) | 3.70.0 |
| <a name="provider_aws.eu-west-1"></a> [aws.eu-west-1](#provider\_aws.eu-west-1) | 3.70.0 |
| <a name="provider_aws.eu-west-2"></a> [aws.eu-west-2](#provider\_aws.eu-west-2) | 3.70.0 |
| <a name="provider_aws.eu-west-3"></a> [aws.eu-west-3](#provider\_aws.eu-west-3) | 3.70.0 |
| <a name="provider_aws.sa-east-1"></a> [aws.sa-east-1](#provider\_aws.sa-east-1) | 3.70.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | 3.70.0 |
| <a name="provider_aws.us-east-2"></a> [aws.us-east-2](#provider\_aws.us-east-2) | 3.70.0 |
| <a name="provider_aws.us-west-1"></a> [aws.us-west-1](#provider\_aws.us-west-1) | 3.70.0 |
| <a name="provider_aws.us-west-2"></a> [aws.us-west-2](#provider\_aws.us-west-2) | 3.70.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_recovery_group"></a> [recovery\_group](#module\_recovery\_group) | ./modules/readiness_recovery_group | n/a |
| <a name="module_routing_control_cluster"></a> [routing\_control\_cluster](#module\_routing\_control\_cluster) | ./modules/routing_control_cluster | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb.ap_northeast_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_northeast_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_northeast_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_south_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_southeast_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ap_southeast_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.ca_central_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_central_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_north_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_west_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_west_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.eu_west_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.sa_east_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.us_east_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.us_east_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.us_west_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb.us_west_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cells_definition"></a> [cells\_definition](#input\_cells\_definition) | Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled: `elasticloadbalancing`, `autoscaling`, `lambda`. Example below: | `map(map(string))` | n/a | yes |
| <a name="input_create_r53_records"></a> [create\_r53\_records](#input\_create\_r53\_records) | Whether or not to create the route53 alias records required. | `bool` | `false` | no |
| <a name="input_create_routing_control_cluster"></a> [create\_routing\_control\_cluster](#input\_create\_routing\_control\_cluster) | Create the Routing Control Cluster and associated resources. | `bool` | `false` | no |
| <a name="input_create_safety_rule_assertion"></a> [create\_safety\_rule\_assertion](#input\_create\_safety\_rule\_assertion) | Whether or not to create an Assertion Saftey Rule | `bool` | `true` | no |
| <a name="input_create_safety_rule_gating"></a> [create\_safety\_rule\_gating](#input\_create\_safety\_rule\_gating) | Whether or not to create an Gating Saftey Rule | `bool` | `false` | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided. Leave null to not create Route53 Alias records (required for LB functionality) . | <pre>object({<br>    name         = optional(string)<br>    private_zone = optional(bool)<br>    vpc_id       = optional(number)<br>    tags         = optional(map(string))<br>    zone_id      = optional(string)<br>  })</pre> | <pre>{<br>  "name": null,<br>  "zone_id": null<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name to prefix resources. | `string` | n/a | yes |
| <a name="input_primary_cell_region"></a> [primary\_cell\_region](#input\_primary\_cell\_region) | (Optional) Region name of which Cell to make Route53 Primary. Defaults to default provider region if not set. | `string` | `null` | no |
| <a name="input_resource_type_name"></a> [resource\_type\_name](#input\_resource\_type\_name) | list of all service types you can pass and their associated Resource Set Type. | `map(string)` | <pre>{<br>  "apigateway": "AWS::ApiGatewayV2::Api",<br>  "autoscaling": "AWS::AutoScaling::AutoScalingGroup",<br>  "cloudwatch": "AWS::CloudWatch::Alarm",<br>  "dynamodb": "AWS::DynamoDB::Table",<br>  "ec2": "AWS::EC2::VPC",<br>  "elasticloadbalancing": "AWS::ElasticLoadBalancingV2::LoadBalancer",<br>  "kafka": "AWS::MSK::Cluster",<br>  "lambda": "AWS::Lambda::Function",<br>  "rds": "AWS::RDS::DBCluster",<br>  "route53": "AWS::Route53::HealthCheck",<br>  "sns": "AWS::SNS::Topic",<br>  "sqs": "AWS::SQS::Queue"<br>}</pre> | no |
| <a name="input_safety_rule_assertion"></a> [safety\_rule\_assertion](#input\_safety\_rule\_assertion) | Configuration of the Assertion Safety Rule | <pre>object({<br>    wait_period_ms = number<br>    inverted       = bool<br>    threshold      = number<br>    type           = string<br>    name_suffix    = string<br>  })</pre> | <pre>{<br>  "inverted": false,<br>  "name_suffix": "MinCellsActive",<br>  "threshold": 1,<br>  "type": "ATLEAST",<br>  "wait_period_ms": 5000<br>}</pre> | no |
| <a name="input_safety_rule_gating"></a> [safety\_rule\_gating](#input\_safety\_rule\_gating) | Configuration of the Gating Safety Rule | <pre>object({<br>    wait_period_ms = number<br>    inverted       = bool<br>    threshold      = number<br>    type           = string<br>    name_suffix    = string<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cells"></a> [cells](#output\_cells) | Cells per region. |
| <a name="output_readiness_checks"></a> [readiness\_checks](#output\_readiness\_checks) | A Readiness Check for each Resource Set |
| <a name="output_recovery_group"></a> [recovery\_group](#output\_recovery\_group) | Recovery Group resource. |
| <a name="output_resource_sets"></a> [resource\_sets](#output\_resource\_sets) | A Resource Set for each service with ARN entries for each region. |
<!-- END_TF_DOCS -->