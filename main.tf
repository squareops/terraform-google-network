locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
  name         = var.name
  subnet_01    = format("%s-%s-public-subnet", local.name, local.environment)
  subnet_02    = var.enable_nat_gateway ? format("%s-%s-private-subnet", local.name, local.environment) : format("%s-%s-public-subnet-2", local.name, local.environment)
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0"

  project_id   = local.project_name
  network_name = format("%s-%s-vpc", local.name, local.environment)
  routing_mode = "GLOBAL"
  subnets = [
    {
      subnet_name               = local.subnet_01
      subnet_ip                 = var.public_subnet_cidr
      subnet_region             = local.region
      ubnet_private_access      = "true"
      subnet_flow_logs          = var.flow_logs
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    },
    {
      subnet_name               = local.subnet_02
      subnet_ip                 = var.private_subnet_cidr
      subnet_region             = local.region
      subnet_private_access     = "true"
      subnet_flow_logs          = var.flow_logs
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
  secondary_ranges = {
    (local.subnet_01) = var.secondary_range_subnet_01

    (local.subnet_02) = var.secondary_range_subnet_02
  }
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
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "3.0.0"
  count                              = var.enable_nat_gateway ? 1 : 0
  project_id                         = local.project_name
  region                             = local.region
  router                             = google_compute_router.router[0].name
  name                               = format("%s-%s-nat", local.name, local.environment)
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  subnetworks = [{
    name                     = format("%s-%s-private-subnet", local.name, local.environment)
    source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
    secondary_ip_range_names = []
  }]
  log_config_enable                = var.log_config_enable_nat
  log_config_filter                = var.log_config_filter_nat
  min_ports_per_vm                 = "128"
  icmp_idle_timeout_sec            = "30"
  tcp_established_idle_timeout_sec = "1200"
  tcp_transitory_idle_timeout_sec  = "30"
  udp_idle_timeout_sec             = "30"
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
