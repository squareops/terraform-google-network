/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "subnetwork" {
  name                       = var.name
  ip_cidr_range              = var.ip_cidr_range
  region                     = var.region
  private_ip_google_access   = var.private_ip_google_access
  private_ipv6_google_access = var.private_ipv6_google_access
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

  secondary_ip_range = var.secondary_ip_range

  purpose    = var.purpose
  role       = var.role
  stack_type = var.stack_type
}
