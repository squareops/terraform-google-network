variable "project_name" {
  description = "The ID or project number of the Google Cloud project."
  type        = string
}

variable "name" {
  description = "A unique name to identify the resources."
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment in which the resources are being deployed."
  type        = string
  default     = ""
}

variable "machine_type" {
  description = "The machine type of the compute instance."
  type        = string
  default     = "e2-medium"
}

variable "zone" {
  description = "The zone in which the compute instance will be created."
  type        = string
  default     = ""
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork to attach the compute instance."
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The name of the network to attach the firewall rules."
  type        = string
  default     = ""
}
