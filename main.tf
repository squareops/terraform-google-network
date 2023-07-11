locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
  name         = var.name
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0"

  project_id       = local.project_name
  network_name     = format("%s-%s-vpc", local.name, local.environment)
  routing_mode     = "GLOBAL"
  subnets          = []
  secondary_ranges = var.secondary_ranges
}

module "subnets" {
  depends_on = [module.vpc]
  source     = "./modules/subnets"

  subnets      = var.subnets
  region       = var.region
  network_name = module.vpc.network_name
  project_id   = local.project_name

}

resource "google_compute_router" "router" {
  count      = var.enable_nat_gateway ? 1 : 0
  project    = local.project_name
  depends_on = [module.vpc]
  name       = format("%s-%s-router", local.name, local.environment)
  network    = module.vpc.network_name
  region     = local.region
}

module "cloud-nat" {
  depends_on                         = [module.vpc]
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "4.0.0"
  count                              = var.enable_nat_gateway ? 1 : 0
  project_id                         = local.project_name
  region                             = local.region
  router                             = google_compute_router.router[0].name
  name                               = format("%s-%s-nat", local.name, local.environment)
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  log_config_enable                  = var.log_config_enable_nat
  log_config_filter                  = var.log_config_filter_nat
  min_ports_per_vm                   = "128"
  icmp_idle_timeout_sec              = "30"
  tcp_established_idle_timeout_sec   = "1200"
  tcp_transitory_idle_timeout_sec    = "30"
  udp_idle_timeout_sec               = "30"
}

module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  version      = "~> 7.0"
  project_id   = local.project_name
  network_name = module.vpc.network_name
  depends_on   = [module.vpc]

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
  network       = module.vpc.network_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.db_private_access ? 1 : 0
  depends_on              = [google_compute_global_address.private_ip_block]
  network                 = module.vpc.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block[count.index].name]
}

module "vpn_server" {
  depends_on   = [module.subnets]
  source       = "./modules/vpn"
  count        = var.create_vpn ? 1 : 0
  project_name = local.project_name
  name         = local.name
  environment  = local.environment
  zone         = var.vpn_zone
  network_name = module.vpc.network_name
  subnetwork   = var.subnets[count.index].name
}