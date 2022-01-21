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
| [aws_route53recoveryreadiness_cell.per_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_cell) | resource |
| [aws_route53recoveryreadiness_readiness_check.per_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_readiness_check) | resource |
| [aws_route53recoveryreadiness_recovery_group.all_regions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_recovery_group) | resource |
| [aws_route53recoveryreadiness_resource_set.each_region_per_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53recoveryreadiness_resource_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cells_definition"></a> [cells\_definition](#input\_cells\_definition) | Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled are defined in `var.resource_type_name`. Example below: | `map(map(string))` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to prefix resources. | `string` | n/a | yes |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions that contain Cells to manage. | `list(string)` | n/a | yes |
| <a name="input_resource_type_name"></a> [resource\_type\_name](#input\_resource\_type\_name) | list of all service types you can pass and their associated Resource Set Type. | `map(string)` | n/a | yes |
| <a name="input_service_list"></a> [service\_list](#input\_service\_list) | List of services that are being enabled. Names correspond with keys to `var.resource_type_name`. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be added to Readiness resources. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cells"></a> [cells](#output\_cells) | Cells per region. |
| <a name="output_readiness_checks"></a> [readiness\_checks](#output\_readiness\_checks) | A Readiness Check for each Resource Set |
| <a name="output_recovery_group"></a> [recovery\_group](#output\_recovery\_group) | Recovery Group resource. |
| <a name="output_resource_sets"></a> [resource\_sets](#output\_resource\_sets) | A Resource Set for each service with ARN entries for each region. |
<!-- END_TF_DOCS -->