# vpn

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall_rules_vpn"></a> [firewall\_rules\_vpn](#module\_firewall\_rules\_vpn) | terraform-google-modules/network/google//modules/firewall-rules | ~> 9.0 |
| <a name="module_service_accounts_vpn"></a> [service\_accounts\_vpn](#module\_service\_accounts\_vpn) | terraform-google-modules/service-accounts/google | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_instance.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment in which the resources are being deployed. | `string` | `""` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type of the compute instance. | `string` | `"e2-medium"` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name to identify the resources. | `string` | `""` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network to attach the firewall rules. | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The ID or project number of the Google Cloud project. | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The name or self\_link of the subnetwork to attach the compute instance. | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The zone in which the compute instance will be created. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpn_name"></a> [vpn\_name](#output\_vpn\_name) | The name of the Pritunl VPN instance. Null if VPN creation is disabled. |
| <a name="output_vpn_zone"></a> [vpn\_zone](#output\_vpn\_zone) | The zone of the Pritunl VPN instance. Null if VPN creation is disabled. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
