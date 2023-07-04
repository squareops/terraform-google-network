## GCP Network Variables
variable "create_vpn" {
  description = "Specifies whether to create a VPN server."
  default     = true
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

variable "flow_logs" {
  description = "Specifies whether the subnet will record and send flow log data to logging."
  default     = "false"
  type        = string
}

variable "log_config_enable_nat" {
  description = "Indicates whether to enable exporting of logs for NAT."
  default     = false
  type        = bool
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
  default     = "skaf"
  type        = string
}

variable "project_name" {
  description = "The project ID where the resources will be deployed."
  default     = "fresh-sanctuary-389006"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Specifies whether to create a NAT gateway."
  default     = true
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

variable "vpn_zone" {
  description = "The zone where the VPN server will be located."
  default     = "asia-south1-a"
  type        = string
}

variable "subnets" {
  type        = list(object({
    name                = string
    ip_cidr_range       = string
    secondary_ip_range = object({
      range_name      = string
      ip_cidr_range   = string
    })
    subnet_private_access      = bool
    subnet_private_ipv6_access = bool
  }))
  description = "The list of subnets being created"
  default = []
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}