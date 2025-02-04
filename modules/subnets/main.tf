/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "subnetwork" {
  name                       = var.name
  ip_cidr_range              = var.ip_cidr_range
  region                     = var.region
  private_ip_google_access   = false #var.private_ip_google_access
  # private_ipv6_google_access = var.private_ipv6_google_access
  network                    = var.network_name
  project                    = var.project_id
  dynamic "log_config" {
    for_each = var.flow_logs ? [1] : []

    content {
      aggregation_interval = var.log_config.aggregation_interval
      flow_sampling        = var.log_config.flow_sampling
      metadata             = var.log_config.metadata
    }
  }

  purpose    = var.purpose
  role       = var.role
  stack_type = var.stack_type
}

# resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
#   name          = "var.name"
#   ip_cidr_range = "10.128.1.0/24"  # Allocate this from the VPC CIDR range
#   region        = var.region     # e.g., "asia-south1"
#   network       = var.network_name

#   # Secondary IP range configuration
#   dynamic "secondary_ip_range" {
#     for_each = var.secondary_ip_range != null ? var.secondary_ip_range : []

#     content {
#       range_name    = secondary_ip_range.value.range_name
#       ip_cidr_range = secondary_ip_range.value.ip_cidr_range
#     }
#   }

#   # Additional configurations (if needed)
#   private_ip_google_access   = var.private_ip_google_access
#   private_ipv6_google_access = var.private_ipv6_google_access
# }

# resource "google_compute_subnetwork" "Private_subnet" {
#   name                       ="${var.name}-private-subnet"
#   ip_cidr_range              = var.ip_cidr_range
#   region                     = var.region
#   private_ip_google_access   = var.private_ip_google_access
#   private_ipv6_google_access = var.private_ipv6_google_access
#   network                    = var.network_name
#   project                    = var.project_id
#   dynamic "log_config" {
#     for_each = var.flow_logs ? [1] : []

#     content {
#       aggregation_interval = var.log_config.aggregation_interval
#       flow_sampling        = var.log_config.flow_sampling
#       metadata             = var.log_config.metadata
#     }
#   }

# dynamic "secondary_ip_range" {
#     for_each = var.secondary_ip_range != null ? var.secondary_ip_range : []

#     content {
#       range_name    = secondary_ip_range.value.range_name
#       ip_cidr_range = secondary_ip_range.value.ip_cidr_range
#     }
#   }

#   purpose    = var.purpose
#   role       = var.role
#   stack_type = var.stack_type
# }
