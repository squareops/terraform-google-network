variable "subnets" {
  description = "List of subnets to create."
  type = list(object({
    name                = string
    ip_cidr_range       = string
    secondary_ip_range = object({
      range_name      = string
      ip_cidr_range   = string
    })
    subnet_private_access      = bool
    subnet_private_ipv6_access = bool
  }))
  default = []
}

variable "region" {
  description = "The region where the subnetworks will be created."
  type        = string
}

variable "network_name" {
  description = "The name of the network where the subnetworks will be created."
  type        = string
}

variable "project_id" {
  description = "The ID of the project where the subnetworks will be created."
  type        = string
}

variable "purpose" {
  description = "The purpose of the subnetworks."
  type        = string
  default = "PRIVATE"
}

variable "role" {
  description = "The role of the subnetworks."
  type        = string
  default = "ACTIVE"
}

variable "stack_type" {
  description = "The stack type of the subnetworks."
  type        = string
  default = "IPV4_ONLY"
}

variable "private_ip_google_access" {
  description = "Flag to enable or disable private IP Google access."
  type        = bool
  default     = false
}

variable "private_ipv6_google_access" {
  description = "Flag to enable or disable private IPv6 Google access."
  type        = bool
  default     = null
}