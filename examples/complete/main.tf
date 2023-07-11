locals {
  region       = "asia-south1"
  environment  = "dev"
  name         = "org"
  project_name = "abc-123456789"
}

module "vpc" {
  source       = "../../"
  name         = local.name
  project_name = local.project_name
  environment  = local.environment
  region       = local.region
  subnets = [
    {
      "name" : "subnet-1",
      "ip_cidr_range" : "10.0.1.0/24",
      "secondary_ip_range" : {
        "range_name" : "secondary-range-1",
        "ip_cidr_range" : "10.0.2.0/24"
      },
      "subnet_private_access" : "false",
      "subnet_private_ipv6_access" : "false"
    },
    {
      "name" : "subnet-2",
      "ip_cidr_range" : "10.0.3.0/24",
      "secondary_ip_range" : {
        "range_name" : "secondary-range-2",
        "ip_cidr_range" : "10.0.4.0/24"
      },
      "subnet_private_access" : "false",
      "subnet_private_ipv6_access" : "false"
    },
  ]
  enable_nat_gateway    = true
  create_vpn            = true
  vpn_zone              = format("%s-a", local.region)
  flow_logs             = true
  log_config_enable_nat = true

}