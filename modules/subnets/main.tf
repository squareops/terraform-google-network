/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "subnetwork" {
  count       = length(var.subnets)
  name                       = var.subnets[count.index].name
  ip_cidr_range              = var.subnets[count.index].ip_cidr_range
  region                     = var.region
  private_ip_google_access   = var.private_ip_google_access
  private_ipv6_google_access = var.private_ipv6_google_access
  network     = var.network_name
  project     = var.project_id
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    filter_expr          = "true"
  }
  secondary_ip_range {
    range_name    = var.subnets[count.index].secondary_ip_range.range_name
    ip_cidr_range = var.subnets[count.index].secondary_ip_range.ip_cidr_range
  }

  lifecycle {
    ignore_changes = [secondary_ip_range]
  }
  purpose          = var.purpose
  role             = var.role
  stack_type       = var.stack_type
}