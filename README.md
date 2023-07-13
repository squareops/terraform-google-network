# GCP VPC Network Terraform Module

![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.

<br>
Terraform module to create Networking resources for workload deployment on Google Cloud.

## Usage Example

```hcl
module "network" {
  source                                          = "<path-to-module>"
  name                                            = "skaf"
  project_name                                    = "<project_name>"
  environment                                     = "dev"
  region                                          = "asia-south1"
  ip_cidr_range                                   = "10.0.0.0/16"
  secondary_range_names                           = ["range-1"]
  secondary_ip_cidr_ranges                        = ["192.168.0.0/20"]
  private_ip_google_access                        = true
  private_ipv6_google_access                      = false
  enable_nat_gateway                              = true
  db_private_access                               = true
  create_vpn                                      = true
  flow_logs                                       = true
  log_config_enable_nat                           = true
}
```
Refer [examples]() for more details.

## Important Note
To prevent destruction interruptions, any resources that have been created outside of Terraform and attached to the resources provisioned by Terraform must be deleted before the module is destroyed.
This module makes it easy to set up a new VPC Network in GCP by defining your network and subnet ranges in a concise syntax.

This module supports creating:

- A Google Virtual Private Network (VPC)
- A Subnet within the VPC
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
| <a name="module_vpn_server"></a> [vpn\_server](#module\_vpn\_server) | ./modules/vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_global_address.private_ip_block](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| <a name="input_create_vpn"></a> [create\_vpn](#input\_create\_vpn) | Specifies whether to create a VPN server. | `bool` | `false` | no |
| <a name="input_db_private_access"></a> [db\_private\_access](#input\_db\_private\_access) | Specifies whether to create a private VPC connection for the database. | `bool` | `false` | no |
| <a name="input_delete_default_internet_gateway_routes"></a> [delete\_default\_internet\_gateway\_routes](#input\_delete\_default\_internet\_gateway\_routes) | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `""` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Specifies whether to create a NAT gateway. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name used for tagging and prefixing resource names being created. | `string` | `"dev"` | no |
| <a name="input_flow_logs"></a> [flow\_logs](#input\_flow\_logs) | Enable or disable flow logging for subnet. | `bool` | `false` | no |
| <a name="input_ip_cidr_range"></a> [ip\_cidr\_range](#input\_ip\_cidr\_range) | The IP CIDR range for the subnet. | `string` | n/a | yes |
| <a name="input_log_config"></a> [log\_config](#input\_log\_config) | The logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples. | <pre>object({<br>    aggregation_interval = string<br>    flow_sampling        = number<br>    metadata             = string<br>  })</pre> | <pre>{<br>  "aggregation_interval": "INTERVAL_10_MIN",<br>  "flow_sampling": 0.5,<br>  "metadata": "INCLUDE_ALL_METADATA"<br>}</pre> | no |
| <a name="input_log_config_enable_nat"></a> [log\_config\_enable\_nat](#input\_log\_config\_enable\_nat) | Indicates whether to enable exporting of logs for NAT. | `bool` | `false` | no |
| <a name="input_log_config_filter_nat"></a> [log\_config\_filter\_nat](#input\_log\_config\_filter\_nat) | Specifies the desired filtering of logs on this NAT. Valid values are: "ERRORS\_ONLY", "TRANSLATIONS\_ONLY", "ALL". | `string` | `"ALL"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type for the VPN server. | `string` | `"e2-medium"` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively. | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | The suffix name for the resources being created. | `string` | `"skaf"` | no |
| <a name="input_private_ip_google_access"></a> [private\_ip\_google\_access](#input\_private\_ip\_google\_access) | Whether instances in the subnet can access Google services using private IP addresses. | `bool` | n/a | yes |
| <a name="input_private_ipv6_google_access"></a> [private\_ipv6\_google\_access](#input\_private\_ipv6\_google\_access) | Whether instances in the subnet can access Google services using IPv6 addresses. | `bool` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project ID where the resources will be deployed. | `string` | `"fresh-sanctuary-389006"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources will be deployed. | `string` | `"asia-south1"` | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |
| <a name="input_secondary_ip_cidr_ranges"></a> [secondary\_ip\_cidr\_ranges](#input\_secondary\_ip\_cidr\_ranges) | List of secondary subnet IP CIDR ranges. | `list(string)` | `[]` | no |
| <a name="input_secondary_range_names"></a> [secondary\_range\_names](#input\_secondary\_range\_names) | List of secondary subnet range names. | `list(string)` | `[]` | no |
| <a name="input_source_subnetwork_ip_ranges_to_nat"></a> [source\_subnetwork\_ip\_ranges\_to\_nat](#input\_source\_subnetwork\_ip\_ranges\_to\_nat) | (Optional) Specifies how NAT should be configured per Subnetwork. Valid values include: ALL\_SUBNETWORKS\_ALL\_IP\_RANGES, ALL\_SUBNETWORKS\_ALL\_PRIMARY\_IP\_RANGES, LIST\_OF\_SUBNETWORKS. Changing this forces a new NAT to be created. Defaults to ALL\_SUBNETWORKS\_ALL\_IP\_RANGES. | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | The VPC resource being created |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | The ID of the VPC being created |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | The URI of the VPC being created |
| <a name="output_region"></a> [region](#output\_region) | The region where the VPC is located. |
| <a name="output_secondary_ip_range"></a> [secondary\_ip\_range](#output\_secondary\_ip\_range) | The details of secondary ip range of subnet |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | List of Subnets created |
| <a name="output_vpn_name"></a> [vpn\_name](#output\_vpn\_name) | The name of the Pritunl VPN instance. Null if VPN creation is disabled. |
| <a name="output_vpn_zone"></a> [vpn\_zone](#output\_vpn\_zone) | The zone of the Pritunl VPN instance. Null if VPN creation is disabled. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
