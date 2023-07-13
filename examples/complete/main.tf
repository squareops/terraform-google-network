locals {
  region       = "asia-south1"
  environment  = "dev"
  name         = "organization_name"
  project_name = "abc-123456789"
}

module "vpc" {
  source                     = "../../"
  name                       = local.name
  project_name               = local.project_name
  environment                = local.environment
  region                     = local.region
  ip_cidr_range              = "10.0.0.0/16"
  secondary_range_names      = ["range-1"]
  secondary_ip_cidr_ranges   = ["192.168.0.0/20"]
  private_ip_google_access   = true
  private_ipv6_google_access = false
  enable_nat_gateway         = true
  db_private_access          = true
  create_vpn                 = true
  flow_logs                  = true
  log_config_enable_nat      = true

}
