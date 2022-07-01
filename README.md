<!-- BEGIN_TF_DOCS -->
# AWS Route53 Application Recovery Controller Module

[Amazon Route53 Application Recovery Controller (Route 53 ARC)](https://aws.amazon.com/blogs/aws/amazon-route-53-application-recovery-controller/) is a set of Route 53 features that help you build applications with high availability. Route 53 ARC can continuously monitor your application's ability to recover from failure and control recovery across multiple AWS Availability Zones, AWS Regions, and on-premises environments. This Terraform module contains both Route 53 ARC readiness and recovery-cluster resources. You can deploy only the readiness resources, or both. For more information about creating a resilience strategy with Route 53 ARC, see [Running recovery-oriented applications with Amazon Route 53 Application Recovery Controller, AWS CI/CD tools, and Terraform](https://aws.amazon.com/blogs/networking-and-content-delivery/running-recovery-oriented-applications-with-amazon-route-53-application-recovery-controller-aws-ci-cd-tools-and-terraform/).

## Example Architecture

<p align="center">
  <img src="https://raw.githubusercontent.com/aws-ia/terraform-aws-route53-recovery-controller/main/images/sample-arc-app-architecture.png" alt="Example Deployment of app with R53 ARC" width="100%">
</p>

## Usage

The primary configuration variable is `cells_definition`. With this variable, you specify the AWS resources per Region that you want Route 53 ARC to monitor. See [examples](https://github.com/aws-ia/terraform-aws-route53-recovery-controller/tree/main/examples/basic) for working examples.

### Readiness resources only

The following `terraform.tfvars` values create a recovery group. The recovery group consists of Region cells `us-east-1` and `us-west-2`, each with a resource set of services `elasticloadbalancing`, `autoscaling`, `dynamodb`, and `ec2-volume` and their Amazon Resource Numbers (ARNs). Readiness checks are associated with each resource set.

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

### Routing control cluster resources and Route 53 alias records

To define a managed Route 53 ARC cluster for your application, add the following Terraform variables.

```terraform
create_recovery_cluster = true

hosted_zone = {
  name = "mycoolapp.com."
}
```

The example shown configures the following:
* A recovery cluster with a single control panel.
* One routing control per Region.
* Safety rules. The default is one, but you can declare more than one.
* One Route 53 health check per routing control.
* Route 53 alias records for each load balancer for the domain specified.

Currently, this module supports active/passive for applications across Regions. The active Region is determined by your `provider` block or by `var.primary_cell_region`. (See "Inputs", later in this document.)

## Available services

The R53 Readiness service supports monitoring many services, most of which have been implemented in this module or can easily be added / extended (even without a PR!). The service keys used in `var.cells_definition` must match a key in `var.resource_type_name` in [variables.tf](./variables.tf#L28) which links to the CloudFormation resource type that is accepted by Readiness service. Example:

```terraform
variable "resource_type_name" {
  type        = map(string)
  description = "list of all service types you can pass and their associated Resource Set Type."

  default = {
    apigateway  = "AWS::ApiGatewayV2::Api"
    autoscaling = "AWS::AutoScaling::AutoScalingGroup"
    cloudwatch  = "AWS::CloudWatch::Alarm"
    dynamodb    = "AWS::DynamoDB::Table"
    ec2-volume  = "AWS::EC2::Volume"
    ...
  }
}
```

### Adding a new service

If a service does not exist in the default `var.resource_type_name` value you can include it without a PR. We also ask that you please do open a PR to include it in default value.

Where you set your variables, simply define a new service key with the associated CloudFormation resource type. You must include all service keys that you plan to use in that root module. In the example below `new-service` is a new service that the Readiness can monitor. We add it to our local deployment and then use it immediately in `var.cells_definition`:

```terraform
resource_type_name = {
  new-service = "AWS::NewService::NewAction"
  dynamodb    = "AWS::DynamoDB::Table"
  ...
}

cells_definition = {
  <region> = {
    new-service = <arn>
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.68 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.ap-northeast-1"></a> [aws.ap-northeast-1](#provider\_aws.ap-northeast-1) | >= 3.68 |
| <a name="provider_aws.ap-northeast-2"></a> [aws.ap-northeast-2](#provider\_aws.ap-northeast-2) | >= 3.68 |
| <a name="provider_aws.ap-northeast-3"></a> [aws.ap-northeast-3](#provider\_aws.ap-northeast-3) | >= 3.68 |
| <a name="provider_aws.ap-south-1"></a> [aws.ap-south-1](#provider\_aws.ap-south-1) | >= 3.68 |
| <a name="provider_aws.ap-southeast-1"></a> [aws.ap-southeast-1](#provider\_aws.ap-southeast-1) | >= 3.68 |
| <a name="provider_aws.ap-southeast-2"></a> [aws.ap-southeast-2](#provider\_aws.ap-southeast-2) | >= 3.68 |
| <a name="provider_aws.ca-central-1"></a> [aws.ca-central-1](#provider\_aws.ca-central-1) | >= 3.68 |
| <a name="provider_aws.eu-central-1"></a> [aws.eu-central-1](#provider\_aws.eu-central-1) | >= 3.68 |
| <a name="provider_aws.eu-north-1"></a> [aws.eu-north-1](#provider\_aws.eu-north-1) | >= 3.68 |
| <a name="provider_aws.eu-west-1"></a> [aws.eu-west-1](#provider\_aws.eu-west-1) | >= 3.68 |
| <a name="provider_aws.eu-west-2"></a> [aws.eu-west-2](#provider\_aws.eu-west-2) | >= 3.68 |
| <a name="provider_aws.eu-west-3"></a> [aws.eu-west-3](#provider\_aws.eu-west-3) | >= 3.68 |
| <a name="provider_aws.sa-east-1"></a> [aws.sa-east-1](#provider\_aws.sa-east-1) | >= 3.68 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | >= 3.68 |
| <a name="provider_aws.us-east-2"></a> [aws.us-east-2](#provider\_aws.us-east-2) | >= 3.68 |
| <a name="provider_aws.us-west-1"></a> [aws.us-west-1](#provider\_aws.us-west-1) | >= 3.68 |
| <a name="provider_aws.us-west-2"></a> [aws.us-west-2](#provider\_aws.us-west-2) | >= 3.68 |

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
| <a name="input_cells_definition"></a> [cells\_definition](#input\_cells\_definition) | Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled are defined in `var.resource_type_name`. For examples, see the variables.tf file"<br>/*<br>cells\_definition = {<br>  us-west-2 = {<br>    elasticloadbalancing = "arn:aws:elasticloadbalancing:us-west-2:<>:loadbalancer/app/<>"<br>    autoscaling          = "arn:aws:autoscaling:us-west-2:<>:autoScalingGroup:*:autoScalingGroupName/<><br>  }<br>}<br>*/ | `map(map(string))` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to prefix resources. | `string` | n/a | yes |
| <a name="input_create_recovery_cluster"></a> [create\_recovery\_cluster](#input\_create\_recovery\_cluster) | Create the Routing Control Cluster and associated resources. | `bool` | `false` | no |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided. Leave null to not create Route53 Alias records (required for LB functionality). | <pre>object({<br>    name         = optional(string)<br>    private_zone = optional(bool)<br>    vpc_id       = optional(string)<br>    tags         = optional(map(string))<br>    zone_id      = optional(string)<br>  })</pre> | <pre>{<br>  "name": null,<br>  "zone_id": null<br>}</pre> | no |
| <a name="input_primary_cell_region"></a> [primary\_cell\_region](#input\_primary\_cell\_region) | (Optional) Region name of which Cell to make Route53 Primary. Defaults to default provider region if not set. | `string` | `null` | no |
| <a name="input_resource_type_name"></a> [resource\_type\_name](#input\_resource\_type\_name) | list of all service types you can pass and their associated Resource Set Type. | `map(string)` | <pre>{<br>  "apigateway": "AWS::ApiGatewayV2::Api",<br>  "autoscaling": "AWS::AutoScaling::AutoScalingGroup",<br>  "cloudwatch": "AWS::CloudWatch::Alarm",<br>  "dynamodb": "AWS::DynamoDB::Table",<br>  "ec2-volume": "AWS::EC2::Volume",<br>  "ec2-vpc": "AWS::EC2::VPC",<br>  "ec2-vpn-cgw": "AWS::EC2::CustomerGateway",<br>  "ec2-vpn-conn": "AWS::EC2::VPNConnection",<br>  "ec2-vpn-gw": "AWS::EC2::VPNGateway",<br>  "elasticloadbalancing": "AWS::ElasticLoadBalancingV2::LoadBalancer",<br>  "kafka": "AWS::MSK::Cluster",<br>  "lambda": "AWS::Lambda::Function",<br>  "rds": "AWS::RDS::DBCluster",<br>  "route53": "AWS::Route53::HealthCheck",<br>  "sns": "AWS::SNS::Topic",<br>  "sqs": "AWS::SQS::Queue"<br>}</pre> | no |
| <a name="input_safety_rule_type"></a> [safety\_rule\_type](#input\_safety\_rule\_type) | Type of safety rules to create. Can only be "assertion" or "gating". | `string` | `"assertion"` | no |
| <a name="input_safety_rules"></a> [safety\_rules](#input\_safety\_rules) | Configuration of the Safety Rules. Key is the name applied to the rule. | <pre>map(object({<br>    wait_period_ms = number<br>    inverted       = bool<br>    threshold      = number<br>    type           = string<br>    name_suffix    = string<br>  }))</pre> | <pre>{<br>  "MinCellsActive": {<br>    "inverted": false,<br>    "name_suffix": "MinCellsActive",<br>    "threshold": 1,<br>    "type": "ATLEAST",<br>    "wait_period_ms": 5000<br>  }<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be added to Readiness resources. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cells"></a> [cells](#output\_cells) | Cells per Region. |
| <a name="output_cluster"></a> [cluster](#output\_cluster) | Cluster information. |
| <a name="output_control_panel"></a> [control\_panel](#output\_control\_panel) | Control Panel information. |
| <a name="output_health_checks"></a> [health\_checks](#output\_health\_checks) | Health checks. |
| <a name="output_r53_aliases"></a> [r53\_aliases](#output\_r53\_aliases) | Route53 alias records, if created. |
| <a name="output_readiness_checks"></a> [readiness\_checks](#output\_readiness\_checks) | A Readiness check for each resource set. |
| <a name="output_recovery_group"></a> [recovery\_group](#output\_recovery\_group) | Recovery group resource. |
| <a name="output_resource_sets"></a> [resource\_sets](#output\_resource\_sets) | A Resource set for each service with ARN entries for each Region. |
| <a name="output_routing_controls"></a> [routing\_controls](#output\_routing\_controls) | Routing controls per cell. |
| <a name="output_safety_rules"></a> [safety\_rules](#output\_safety\_rules) | Safety rules. |
<!-- END_TF_DOCS -->