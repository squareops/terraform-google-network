## GCP Network Variables
variable "create_vpn" {
  description = "Specifies whether to create a VPN server."
  default     = false
  type        = bool
}

variable "db_private_access" {
  description = "Specifies whether to create a private VPC connection for the database."
  default     = false
  type        = bool
}

variable "environment" {
  description = "The environment name used for tagging and prefixing resource names being created."
  default     = "dev"
  type        = string
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "delete_default_internet_gateway_routes" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  default     = false
}

variable "mtu" {
  type        = number
  description = "The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively."
  default     = 0
}

variable "log_config" {
  description = "The logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples."
  type = object({
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
  })

  default = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

variable "log_config_filter_nat" {
  description = "Specifies the desired filtering of logs on this NAT. Valid values are: \"ERRORS_ONLY\", \"TRANSLATIONS_ONLY\", \"ALL\"."
  default     = "ALL"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the VPN server."
  default     = "e2-medium"
  type        = string
}

variable "name" {
  description = "The suffix name for the resources being created."
  type        = string
}

variable "project_name" {
  description = "The project ID where the resources will be deployed."
  default     = "fresh-sanctuary-389006"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Specifies whether to create a NAT gateway."
  default     = false
  type        = bool
}

variable "region" {
  description = "The region where the resources will be deployed."
  default     = "asia-south1"
  type        = string
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "(Optional) Specifies how NAT should be configured per Subnetwork. Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created. Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES."
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  type        = string
}

variable "secondary_ip_range" {
  description = "List of secondary IP ranges for each private subnet"
  type = list(object({
    range_name    = string
    ip_cidr_range = string
  }))
  default = []
}

variable "ip_cidr_range" {
  type        = list(string)
  description = "The IP CIDR range for the subnet."
  default     = []
}

variable "private_ip_google_access" {
  type        = bool
  description = "Whether instances in the subnet can access Google services using private IP addresses."
  default     = true
}

variable "private_ipv6_google_access" {
  type        = bool
  description = "Whether instances in the subnet can access Google services using IPv6 addresses."
  default     = false
}

variable "vpc_flow_logs" {
  type        = bool
  default     = false
  description = "Enable or disable flow logging for subnets."
}

variable "private_ip_cidr_range" {
  description = "List of CIDR ranges for private subnets"
  type        = list(string)
  default     = []
}

variable "lb_ip_cidr_range" {
  description = "The IP CIDR range for the subnet."
  type        = string
  default     = ""
}
