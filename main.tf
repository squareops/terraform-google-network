locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
  name         = var.name
}


resource "google_compute_network" "network" {
  name                            = "${var.name}-vpc"
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  project                         = var.project_name
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
  mtu                             = var.mtu
}

module "subnets" {
  depends_on = [google_compute_network.network]
  source     = "./modules/subnets"
  for_each                   = { for idx, cidr in var.ip_cidr_range : cidr => idx }
  name                       = format("%s-%s-public-subnet-%d", var.environment, var.name, each.value + 1)
  ip_cidr_range              = each.key
  private_ip_google_access   = false #var.private_ip_google_access
  # private_ipv6_google_access = var.private_ipv6_google_access
  region                     = var.region
  secondary_ip_range         = var.secondary_ip_range
  network_name               = google_compute_network.network.self_link
  project_id                 = local.project_name
  flow_logs                  = var.vpc_flow_logs
  log_config                 = var.log_config
}

module "private_subnet" {
  depends_on                 = [google_compute_network.network]
  for_each                   = { for idx, cidr in var.private_ip_cidr_range : cidr => idx } # Create a map for easy access to the index
  source                     = "./modules/Private_subnet"
  name                       = format("%s-%s-private-subnet-%d", var.environment, var.name, each.value + 1)
  private_ip_cidr_range      = each.key # Pass the CIDR range (10.x.x.x/16) directly as a string
  private_ip_google_access   = true
  # private_ipv6_google_access = var.private_ipv6_google_access
  region                     = var.region
  secondary_ip_range         = [var.secondary_ip_range[each.value]] # Pass as a list of objects
  network_name               = google_compute_network.network.self_link
  project_id                 = local.project_name
  flow_logs                  = var.vpc_flow_logs
  log_config                 = var.log_config
}

module "LB_subnet" {
  depends_on = [google_compute_network.network]
  source     = "./modules/LB_subnet"
  name                       = format("%s-%s-internal-lb-proxy-subnet", var.environment, var.name)
  lb_ip_cidr_range           = var.lb_ip_cidr_range
  private_ip_google_access   = true #var.private_ip_google_access
  # private_ipv6_google_access = var.private_ipv6_google_access
  region                     = var.region
  secondary_ip_range         = var.secondary_ip_range # Secondary IP ranges for private subnet
  network_name               = google_compute_network.network.self_link
  project_id                 = local.project_name
  flow_logs                  = var.vpc_flow_logs
  log_config                 = var.log_config
}

resource "google_compute_router" "router" {
  count      = var.enable_nat_gateway ? 1 : 0
  project    = local.project_name
  depends_on = [google_compute_network.network]
  name       = format("%s-%s-router", local.name, local.environment)
  network    = google_compute_network.network.self_link
  region     = local.region
}

module "cloud-nat" {
  depends_on                         = [google_compute_network.network, module.private_subnet] # Ensure the private subnet is ready
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "5.0"
  count                              = var.enable_nat_gateway ? 1 : 0
  project_id                         = local.project_name
  region                             = local.region
  router                             = google_compute_router.router[0].name
  name                               = format("%s-%s-nat", local.name, local.environment)
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  log_config_enable                  = var.vpc_flow_logs
  log_config_filter                  = var.log_config_filter_nat
  min_ports_per_vm                   = "128"
  icmp_idle_timeout_sec              = "30"
  tcp_established_idle_timeout_sec   = "1200"
  tcp_transitory_idle_timeout_sec    = "30"
  udp_idle_timeout_sec               = "30"
  subnetworks = [
    for idx, cidr in tolist(var.private_ip_cidr_range) : {
      name                     = format("%s-%s-private-subnet-%d", var.environment, var.name, idx + 1) # Corrected here
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
      secondary_ip_range_names = []
    }
  ]
}

module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  version      = "~> 9.0"
  project_id   = local.project_name
  network_name = google_compute_network.network.self_link
  depends_on   = [google_compute_network.network]

  rules = [
    {
      name                    = format("%s-%s-http-allow", local.name, local.environment)
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["http-server"]
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["80"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = format("%s-%s-https-allow", local.name, local.environment)
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = ["https-server"]
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["443"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
  ]
}

resource "google_compute_global_address" "private_ip_block" {
  count         = var.db_private_access ? 1 : 0
  project       = local.project_name
  name          = format("%s-%s-private-ip-block", local.name, local.environment)
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 20
  network       = google_compute_network.network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.db_private_access ? 1 : 0
  depends_on              = [google_compute_global_address.private_ip_block]
  network                 = google_compute_network.network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block[count.index].name]
}

module "vpn_server" {
  depends_on   = [module.private_subnet]
  source       = "./modules/vpn"
  count        = var.create_vpn ? 1 : 0
  project_name = local.project_name
  name         = local.name
  environment  = local.environment
  zone         = format("%s-a", var.region)
  network_name = google_compute_network.network.self_link
  subnetwork   = module.subnets.subnet_name[0]
  machine_type = var.machine_type
}
