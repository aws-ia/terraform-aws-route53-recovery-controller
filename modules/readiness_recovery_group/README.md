## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

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
| <a name="input_cells_definition"></a> [cells\_definition](#input\_cells\_definition) | Nested map where the key is a region you want to enable and keys referring to resource arns to enable. Services enabled: `elasticloadbalancing`, `autoscaling`, `lambda`. Example below: | `map(map(string))` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to prefix resources. | `string` | n/a | yes |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions that contain Cells to manage. | `list(string)` | n/a | yes |
| <a name="input_resource_type_name"></a> [resource\_type\_name](#input\_resource\_type\_name) | n/a | `any` | n/a | yes |
| <a name="input_service_list"></a> [service\_list](#input\_service\_list) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cells"></a> [cells](#output\_cells) | Cells per region. |
| <a name="output_readiness_checks"></a> [readiness\_checks](#output\_readiness\_checks) | A Readiness Check for each Resource Set |
| <a name="output_recovery_group"></a> [recovery\_group](#output\_recovery\_group) | Recovery Group resource. |
| <a name="output_resource_sets"></a> [resource\_sets](#output\_resource\_sets) | A Resource Set for each service with ARN entries for each region. |
