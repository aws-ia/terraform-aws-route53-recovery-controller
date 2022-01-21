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
| [aws_route53recoverycontrolconfig_safety_rule.assertion_or_gating](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoverycontrolconfig_safety_rule) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cells_definition"></a> [cells\_definition](#input\_cells\_definition) | Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled are defined in `var.resource_type_name`. Example below: | `map(map(string))` | n/a | yes |
| <a name="input_lb_info"></a> [lb\_info](#input\_lb\_info) | Map of lb info from each region declared. | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to prefix resources. | `string` | n/a | yes |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions that contain Cells to manage. | `list(string)` | n/a | yes |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | Info about the hosted zone. If the `name` or `zone_id` is not passed, a search will be performed using the values provided. | <pre>object({<br>    name         = optional(string)<br>    private_zone = optional(bool)<br>    vpc_id       = optional(number)<br>    tags         = optional(map(string))<br>    zone_id      = optional(string)<br>  })</pre> | <pre>{<br>  "name": null,<br>  "zone_id": null<br>}</pre> | no |
| <a name="input_primary_cell_region"></a> [primary\_cell\_region](#input\_primary\_cell\_region) | (Optional) Region name of which Cell to make Route53 Primary. Defaults to default provider region if not set. | `string` | `null` | no |
| <a name="input_safety_rule_type"></a> [safety\_rule\_type](#input\_safety\_rule\_type) | Type of safety rules to create. Can only be "assertion" or "gating". | `string` | `"assertion"` | no |
| <a name="input_safety_rules"></a> [safety\_rules](#input\_safety\_rules) | Configuration of the Safety Rules | <pre>map(object({<br>    wait_period_ms = number<br>    inverted       = bool<br>    threshold      = number<br>    type           = string<br>    name_suffix    = string<br>  }))</pre> | <pre>{<br>  "MinCellsActive": {<br>    "inverted": false,<br>    "name_suffix": "MinCellsActive",<br>    "threshold": 1,<br>    "type": "ATLEAST",<br>    "wait_period_ms": 5000<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | Cluster info. |
| <a name="output_control_panel"></a> [control\_panel](#output\_control\_panel) | Control Panel info. |
| <a name="output_health_checks"></a> [health\_checks](#output\_health\_checks) | Health Checks. |
| <a name="output_r53_aliases"></a> [r53\_aliases](#output\_r53\_aliases) | Route53 Alias Records, if created. |
| <a name="output_routing_controls"></a> [routing\_controls](#output\_routing\_controls) | Routing Controls per Cell. |
| <a name="output_safety_rules"></a> [safety\_rules](#output\_safety\_rules) | Safety Rules. |
<!-- END_TF_DOCS -->