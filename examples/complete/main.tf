locals {
  region       = "asia-south1"
  environment  = "dev"
  name         = "organization_name"
  project_name = "abc-123456789"
}

module "vpc" {
  source        = "squareops/network/google"
  name          = local.name
  project_name  = local.project_name
  environment   = local.environment
  region        = local.region
  ip_cidr_range = "10.0.0.0/16"
  secondary_ip_range = [
    {
      range_name    = "tf-test-secondary-range1"
      ip_cidr_range = "192.168.10.0/24"
    },
    {
      range_name    = "tf-test-secondary-range2"
      ip_cidr_range = "192.168.11.0/24"
    }
  ]
  private_ip_google_access   = true
  private_ipv6_google_access = false
  enable_nat_gateway         = true
  db_private_access          = false
  create_vpn                 = true
  vpc_flow_logs              = true

}
