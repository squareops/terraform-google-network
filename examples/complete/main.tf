locals {
  region       = "asia-south1"
  environment  = "dev"
  name         = "test"
  project_name = "pelagic-tracker-447005-v4"

  # Define the private CIDR ranges only once
  private_ip_cidr_range = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

module "vpc" {
  source                = "../../"
  name                  = local.name
  project_name          = local.project_name
  environment           = local.environment
  region                = local.region
  ip_cidr_range         = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # Public subnet CIDR
  private_ip_cidr_range = local.private_ip_cidr_range # Pass CIDR ranges for private subnets
  lb_ip_cidr_range      = "10.0.8.0/24"                         # Load balancer proxy subnet

  # Dynamically generate secondary IP ranges
  secondary_ip_range = [
    for idx, cidr in local.private_ip_cidr_range : {
      range_name    = format("tf-test-secondary-range%d", idx + 1)
      ip_cidr_range = format("192.168.%d.0/24", idx + 10) # Starts from 192.168.10.0/24, 192.168.11.0/24, etc.
    }
  ]
  private_ip_google_access = true
  enable_nat_gateway       = true
  db_private_access        = true
  create_vpn               = false
  vpc_flow_logs            = false
  # private_ipv6_google_access = false
}
