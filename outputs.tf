output "region" {
  description = "The region where the VPC is located."
  value       = var.region
}

output "vpc_details" {
  description = "Details of the VPC being created, including name, ID, and self-link."
  value = {
    name      = google_compute_network.network.name
    id        = google_compute_network.network.id
    self_link = google_compute_network.network.self_link
  }
}

output "vpn_details" {
  description = "Details of the Pritunl VPN instance. Null if VPN creation is disabled."
  value = var.create_vpn ? {
    name = module.vpn_server[0].vpn_name
    zone = module.vpn_server[0].vpn_zone
  } : null
}

output "public_subnet_details" {
  description = "Details of all public subnets created, including their names and CIDR ranges."
  value = [
    for subnet in module.subnets : {
      name               = subnet.subnet_name
      cidr               = subnet.subnet_cidr
      # secondary_ip_range = subnet.secondary_ip_range
    }
  ]
}

output "private_subnet_details" {
  description = "Details of all private subnets created, including their names, CIDR ranges, and secondary IP ranges."
  value = [
    for subnet in module.private_subnet : {
      name               = subnet.name
      private_ip_cidr    = subnet.private_ip_cidr
      secondary_ip_range = subnet.secondary_ip_range
    }
  ]
}

output "lb_subnet_details" {
  description = "Details of LB subnets created, including their names and CIDR ranges."
  value = [
    for idx in range(length(module.LB_subnet.subnet_name)) : {
      name = module.LB_subnet.subnet_name[idx]
      cidr = module.LB_subnet.subnet_cidr[idx]
    }
  ]
}

# output "lb_subnet_details" {
#   description = "Details of LB subnets created, including their names and CIDR ranges."
#   value = [
#     for subnet in module.LB_subnet : {
#       name               = subnet.subnet_name
#       private_ip_cidr    = subnet.subnet_cidr
#       # secondary_ip_range = subent.secondary_ip_range
#     }
#   ]
# }
