# Terraform Network Module

This module makes it easy to set up a new VPC Network in GCP by defining your network and subnet ranges in a concise syntax.

It supports creating:

- A Google Virtual Private Network (VPC)
- Subnets within the VPC
- Private service connection in VPC
- A Google Cloud NAT with Router
- A VPN Server with External IP

### Configure a Service Account
In order to execute this module you must have a Service Account with the following roles on the organization or folder:

- roles/compute.networkAdmin
- roles/compute.securityAdmin

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.51, < 5.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.51, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.51, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud-nat"></a> [cloud-nat](#module\_cloud-nat) | terraform-google-modules/cloud-nat/google | 4.0.0 |
| <a name="module_firewall_rules"></a> [firewall\_rules](#module\_firewall\_rules) | terraform-google-modules/network/google//modules/firewall-rules | ~> 7.0 |
| <a name="module_subnets"></a> [subnets](#module\_subnets) | ./modules/subnets | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | ~> 7.0 |
| <a name="module_vpn_server"></a> [vpn\_server](#module\_vpn\_server) | ./modules/vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.private_ip_block](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_vpn"></a> [create\_vpn](#input\_create\_vpn) | Specifies whether to create a VPN server. | `bool` | `false` | no |
| <a name="input_db_private_access"></a> [db\_private\_access](#input\_db\_private\_access) | Specifies whether to create a private VPC connection for the database. | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Specifies whether to create a NAT gateway. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name used for tagging and prefixing resource names being created. | `string` | `"dev"` | no |
| <a name="input_log_config"></a> [log\_config](#input\_log\_config) | The logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples. | <pre>object({<br>    aggregation_interval = string<br>    flow_sampling        = number<br>    metadata             = string<br>  })</pre> | <pre>{<br>  "aggregation_interval": "INTERVAL_10_MIN",<br>  "flow_sampling": 0.5,<br>  "metadata": "INCLUDE_ALL_METADATA"<br>}</pre> | no |
| <a name="input_log_config_enable_nat"></a> [log\_config\_enable\_nat](#input\_log\_config\_enable\_nat) | Indicates whether to enable exporting of logs for NAT. | `bool` | `false` | no |
| <a name="input_log_config_filter_nat"></a> [log\_config\_filter\_nat](#input\_log\_config\_filter\_nat) | Specifies the desired filtering of logs on this NAT. Valid values are: "ERRORS\_ONLY", "TRANSLATIONS\_ONLY", "ALL". | `string` | `"ALL"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type for the VPN server. | `string` | `"e2-medium"` | no |
| <a name="input_name"></a> [name](#input\_name) | The suffix name for the resources being created. | `string` | `"skaf"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project ID where the resources will be deployed. | `string` | `"fresh-sanctuary-389006"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources will be deployed. | `string` | `"asia-south1"` | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_source_subnetwork_ip_ranges_to_nat"></a> [source\_subnetwork\_ip\_ranges\_to\_nat](#input\_source\_subnetwork\_ip\_ranges\_to\_nat) | (Optional) Specifies how NAT should be configured per Subnetwork. Valid values include: ALL\_SUBNETWORKS\_ALL\_IP\_RANGES, ALL\_SUBNETWORKS\_ALL\_PRIMARY\_IP\_RANGES, LIST\_OF\_SUBNETWORKS. Changing this forces a new NAT to be created. Defaults to ALL\_SUBNETWORKS\_ALL\_IP\_RANGES. | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets being created | <pre>list(object({<br>    name          = string<br>    ip_cidr_range = string<br>    secondary_ip_range = object({<br>      range_name    = string<br>      ip_cidr_range = string<br>    })<br>    subnet_private_access      = bool<br>    subnet_private_ipv6_access = bool<br>  }))</pre> | `[]` | no |
| <a name="input_vpn_zone"></a> [vpn\_zone](#input\_vpn\_zone) | The zone where the VPN server will be located. | `string` | `"asia-south1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_region"></a> [region](#output\_region) | The region where the VPC is located. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | List of Subnets created |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC network. |
| <a name="output_vpc_selflink"></a> [vpc\_selflink](#output\_vpc\_selflink) | The URI (self-link) of the VPC network. |
| <a name="output_vpn_name"></a> [vpn\_name](#output\_vpn\_name) | The name of the Pritunl VPN instance. Null if VPN creation is disabled. |
| <a name="output_vpn_zone"></a> [vpn\_zone](#output\_vpn\_zone) | The zone of the Pritunl VPN instance. Null if VPN creation is disabled. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
