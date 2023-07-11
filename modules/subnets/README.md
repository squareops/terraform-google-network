# subnets

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_subnetwork.subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_config"></a> [log\_config](#input\_log\_config) | The logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples. | <pre>object({<br>    aggregation_interval = string<br>    flow_sampling        = number<br>    metadata             = string<br>  })</pre> | <pre>{<br>  "aggregation_interval": "INTERVAL_10_MIN",<br>  "flow_sampling": 0.5,<br>  "metadata": "INCLUDE_ALL_METADATA"<br>}</pre> | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network where the subnetworks will be created. | `string` | n/a | yes |
| <a name="input_private_ip_google_access"></a> [private\_ip\_google\_access](#input\_private\_ip\_google\_access) | Flag to enable or disable private IP Google access. | `bool` | `false` | no |
| <a name="input_private_ipv6_google_access"></a> [private\_ipv6\_google\_access](#input\_private\_ipv6\_google\_access) | Flag to enable or disable private IPv6 Google access. | `bool` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project where the subnetworks will be created. | `string` | n/a | yes |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the subnetworks. | `string` | `"PRIVATE"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the subnetworks will be created. | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | The role of the subnetworks. | `string` | `"ACTIVE"` | no |
| <a name="input_stack_type"></a> [stack\_type](#input\_stack\_type) | The stack type of the subnetworks. | `string` | `"IPV4_ONLY"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets to create. | <pre>list(object({<br>    name          = string<br>    ip_cidr_range = string<br>    secondary_ip_range = object({<br>      range_name    = string<br>      ip_cidr_range = string<br>    })<br>    subnet_private_access      = bool<br>    subnet_private_ipv6_access = bool<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The created subnet resources |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
