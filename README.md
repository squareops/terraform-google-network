# GCP VPC Network Terraform Module

![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.

<br>
Terraform module to create Networking resources for workload deployment on Google Cloud.

## Usage Example

```hcl
module "network" {
  source                                          = "squareops/network/google"
  name                                            = "identifier"
  project_name                                    = "project_name"
  environment                                     = "dev"
  region                                          = "asia-south1"
  ip_cidr_range                                   = "10.0.0.0/16"
  secondary_ip_range = [
    {
      range_name    = "tf-test-secondary-range1"
      ip_cidr_range = "192.168.10.0/24"
    },
    {
      range_name    = "tf-test-secondary-range2"
      ip_cidr_range = "192.168.11.0/24"
    }
  ]
  private_ip_google_access                        = true
  private_ipv6_google_access                      = false
  enable_nat_gateway                              = true
  db_private_access                               = true
  create_vpn                                      = true
  vpc_flow_logs                                   = true
}
```
Refer [examples](https://github.com/sq-ia/terraform-google-network/blob/main/examples/complete) for more details.

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
In order to execute this module you must have a Service Account with the roles mentioned in [IAM.md](https://github.com/sq-ia/terraform-google-network/blob/main/IAM.md).



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
| <a name="module_LB_subnet"></a> [LB\_subnet](#module\_LB\_subnet) | ./modules/LB_subnet | n/a |
| <a name="module_cloud-nat"></a> [cloud-nat](#module\_cloud-nat) | terraform-google-modules/cloud-nat/google | 5.0 |
| <a name="module_firewall_rules"></a> [firewall\_rules](#module\_firewall\_rules) | terraform-google-modules/network/google//modules/firewall-rules | ~> 9.0 |
| <a name="module_private_subnet"></a> [private\_subnet](#module\_private\_subnet) | ./modules/Private_subnet | n/a |
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
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Specifies whether to create a NAT gateway. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name used for tagging and prefixing resource names being created. | `string` | `"dev"` | no |
| <a name="input_ip_cidr_range"></a> [ip\_cidr\_range](#input\_ip\_cidr\_range) | The IP CIDR range for the subnet. | `string` | n/a | yes |
| <a name="input_lb_ip_cidr_range"></a> [lb\_ip\_cidr\_range](#input\_lb\_ip\_cidr\_range) | The IP CIDR range for the subnet. | `string` | n/a | yes |
| <a name="input_log_config"></a> [log\_config](#input\_log\_config) | The logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples. | <pre>object({<br/>    aggregation_interval = string<br/>    flow_sampling        = number<br/>    metadata             = string<br/>  })</pre> | <pre>{<br/>  "aggregation_interval": "INTERVAL_10_MIN",<br/>  "flow_sampling": 0.5,<br/>  "metadata": "INCLUDE_ALL_METADATA"<br/>}</pre> | no |
| <a name="input_log_config_filter_nat"></a> [log\_config\_filter\_nat](#input\_log\_config\_filter\_nat) | Specifies the desired filtering of logs on this NAT. Valid values are: "ERRORS\_ONLY", "TRANSLATIONS\_ONLY", "ALL". | `string` | `"ALL"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | The machine type for the VPN server. | `string` | `"e2-medium"` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively. | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | The suffix name for the resources being created. | `string` | n/a | yes |
| <a name="input_private_ip_cidr_range"></a> [private\_ip\_cidr\_range](#input\_private\_ip\_cidr\_range) | List of CIDR ranges for private subnets | `list(string)` | `[]` | no |
| <a name="input_private_ip_google_access"></a> [private\_ip\_google\_access](#input\_private\_ip\_google\_access) | Whether instances in the subnet can access Google services using private IP addresses. | `bool` | `true` | no |
| <a name="input_private_ipv6_google_access"></a> [private\_ipv6\_google\_access](#input\_private\_ipv6\_google\_access) | Whether instances in the subnet can access Google services using IPv6 addresses. | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project ID where the resources will be deployed. | `string` | `"fresh-sanctuary-389006"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the resources will be deployed. | `string` | `"asia-south1"` | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |
| <a name="input_secondary_ip_range"></a> [secondary\_ip\_range](#input\_secondary\_ip\_range) | List of secondary IP ranges for each private subnet | <pre>list(object({<br/>    range_name    = string<br/>    ip_cidr_range = string<br/>  }))</pre> | `[]` | no |
| <a name="input_source_subnetwork_ip_ranges_to_nat"></a> [source\_subnetwork\_ip\_ranges\_to\_nat](#input\_source\_subnetwork\_ip\_ranges\_to\_nat) | (Optional) Specifies how NAT should be configured per Subnetwork. Valid values include: ALL\_SUBNETWORKS\_ALL\_IP\_RANGES, ALL\_SUBNETWORKS\_ALL\_PRIMARY\_IP\_RANGES, LIST\_OF\_SUBNETWORKS. Changing this forces a new NAT to be created. Defaults to ALL\_SUBNETWORKS\_ALL\_IP\_RANGES. | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |
| <a name="input_vpc_flow_logs"></a> [vpc\_flow\_logs](#input\_vpc\_flow\_logs) | Enable or disable flow logging for subnets. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_subnet_details"></a> [lb\_subnet\_details](#output\_lb\_subnet\_details) | Details of LB subnets created, including their names and CIDR ranges. |
| <a name="output_private_subnet_details"></a> [private\_subnet\_details](#output\_private\_subnet\_details) | Details of all private subnets created, including their names, CIDR ranges, and secondary IP ranges. |
| <a name="output_public_subnet_details"></a> [public\_subnet\_details](#output\_public\_subnet\_details) | Details of all public subnets created, including their names and CIDR ranges. |
| <a name="output_region"></a> [region](#output\_region) | The region where the VPC is located. |
| <a name="output_vpc_details"></a> [vpc\_details](#output\_vpc\_details) | Details of the VPC being created, including name, ID, and self-link. |
| <a name="output_vpn_details"></a> [vpn\_details](#output\_vpn\_details) | Details of the Pritunl VPN instance. Null if VPN creation is disabled. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Contribute & Issue Report

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/sq-ia/terraform-google-network/issues) on GitHub
  2. Search to check if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Make sure to provide enough context and details.

## License

Apache License, Version 2.0, January 2004 (https://www.apache.org/licenses/LICENSE-2.0)

## Support Us

To support our GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/sq-ia/terraform-google-network)

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Staring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 5 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

To find more information about our company, visit [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).
