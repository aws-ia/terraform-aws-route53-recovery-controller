# AWS Route53 Application Recovery Controller Module

AWS Route53 Application Recovery Controller (ARC) is a set of capabilities that continuously monitors an application’s ability to recover from failures and controls application recovery across multiple AWS Availability Zones, AWS Regions, and on premises environments to help you to build applications that must deliver very high availability.

This module can deploy just the Readiness Resources or both the Readiness and Recovery Cluster Resources. Much of this code was adapted from [this AWS Blog](https://aws.amazon.com/blogs/networking-and-content-delivery/running-recovery-oriented-applications-with-amazon-route-53-application-recovery-controller-aws-ci-cd-tools-and-terraform/) which can also provide more context on ARC design and terms.

## Usage

The primary configuration item is `cells_definition` which is a nested map that tells ARC which resources per region need to be added to ARC. Example usage below.

### Readiness Resources Only

The below `terraform.tfvars` variable values would create a Recovery Group with Cells for `us-east-1` and `us-west-2`, a Resource Set for services `elasticloadbalancing`, `autoscaling`, `dynamodb`, and `ec2-volume` for each region and arn is provided, and Readiness Checks for each service.

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

### Routing Control Cluster Resources & R53 Alias Records

To define an ARC cluster for managed failover you should add the below values to as terraform variables. Currently we support ACTIVE/PASSIVE for applications across regions. The ACTIVE region is determined by your `provider` block or by `var.primary_cell_region`.

Below would setup a Recovery Cluster with a single Control Panel, 1 Routing Control per region, Safety Rules (default 1, 1+ may be declared), 1 R53 Health Check per Routing Control, and R53 Alias records for each LB for the domain specified.

```terraform
create_recovery_cluster = false

hosted_zone = {
  name         = "mycoolapp.com."
}
```

## Contributing to this Module

### Adding a new service

If any services are added to ARC or missing from this module, to include please make the module aware of the CFN Service Type by completing below steps:

1. add service to `var.resource_type_name` variable type definition
1. add service key (from 1) to validation check for `var.cells_definition` in variables.tf

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
| <a name="input_cells_definition"></a> [cells\_definition](#input\_cells\_definition) | Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled are defined in `var.resource_type_name`. Example below: | `map(map(string))` | n/a | yes |
| <a name="input_create_recovery_cluster"></a> [create\_recovery\_cluster](#input\_create\_recovery\_cluster) | Create the Routing Control Cluster and associated resources. | `bool` | `false` | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided. Leave null to not create Route53 Alias records (required for LB functionality) . | <pre>object({<br>    name         = optional(string)<br>    private_zone = optional(bool)<br>    vpc_id       = optional(number)<br>    tags         = optional(map(string))<br>    zone_id      = optional(string)<br>  })</pre> | <pre>{<br>  "name": null,<br>  "zone_id": null<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name to prefix resources. | `string` | n/a | yes |
| <a name="input_primary_cell_region"></a> [primary\_cell\_region](#input\_primary\_cell\_region) | (Optional) Region name of which Cell to make Route53 Primary. Defaults to default provider region if not set. | `string` | `null` | no |
| <a name="input_resource_type_name"></a> [resource\_type\_name](#input\_resource\_type\_name) | list of all service types you can pass and their associated Resource Set Type. | `map(string)` | <pre>{<br>  "apigateway": "AWS::ApiGatewayV2::Api",<br>  "autoscaling": "AWS::AutoScaling::AutoScalingGroup",<br>  "cloudwatch": "AWS::CloudWatch::Alarm",<br>  "dynamodb": "AWS::DynamoDB::Table",<br>  "ec2-volume": "AWS::EC2::Volume",<br>  "ec2-vpc": "AWS::EC2::VPC",<br>  "ec2-vpn-cgw": "AWS::EC2::CustomerGateway",<br>  "ec2-vpn-conn": "AWS::EC2::VPNConnection",<br>  "ec2-vpn-gw": "AWS::EC2::VPNGateway",<br>  "elasticloadbalancing": "AWS::ElasticLoadBalancingV2::LoadBalancer",<br>  "kafka": "AWS::MSK::Cluster",<br>  "lambda": "AWS::Lambda::Function",<br>  "rds": "AWS::RDS::DBCluster",<br>  "route53": "AWS::Route53::HealthCheck",<br>  "sns": "AWS::SNS::Topic",<br>  "sqs": "AWS::SQS::Queue"<br>}</pre> | no |
| <a name="input_safety_rule_type"></a> [safety\_rule\_type](#input\_safety\_rule\_type) | Type of safety rules to create. Can only be "assertion" or "gating". | `string` | `"assertion"` | no |
| <a name="input_safety_rules"></a> [safety\_rules](#input\_safety\_rules) | Configuration of the Safety Rules. Key is the name applied to the rule. | <pre>map(object({<br>    wait_period_ms = number<br>    inverted       = bool<br>    threshold      = number<br>    type           = string<br>    name_suffix    = string<br>  }))</pre> | <pre>{<br>  "MinCellsActive": {<br>    "inverted": false,<br>    "name_suffix": "MinCellsActive",<br>    "threshold": 1,<br>    "type": "ATLEAST",<br>    "wait_period_ms": 5000<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be added to Readiness resources. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cells"></a> [cells](#output\_cells) | Cells per region. |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | Cluster info. |
| <a name="output_control_panel"></a> [control\_panel](#output\_control\_panel) | Control Panel info. |
| <a name="output_health_checks"></a> [health\_checks](#output\_health\_checks) | Health Checks. |
| <a name="output_r53_aliases"></a> [r53\_aliases](#output\_r53\_aliases) | Route53 Alias Records, if created. |
| <a name="output_readiness_checks"></a> [readiness\_checks](#output\_readiness\_checks) | A Readiness Check for each Resource Set |
| <a name="output_recovery_group"></a> [recovery\_group](#output\_recovery\_group) | Recovery Group resource. |
| <a name="output_resource_sets"></a> [resource\_sets](#output\_resource\_sets) | A Resource Set for each service with ARN entries for each region. |
| <a name="output_routing_controls"></a> [routing\_controls](#output\_routing\_controls) | Routing Controls per Cell. |
| <a name="output_safety_rules"></a> [safety\_rules](#output\_safety\_rules) | Safety Rules. |
