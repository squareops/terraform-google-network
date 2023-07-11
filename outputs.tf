output "region" {
  description = "The region where the VPC is located."
  value       = var.region
}

output "vpc_name" {
  description = "The name of the VPC network."
  value       = module.vpc.network_name
}

output "vpn_name" {
  description = "The name of the Pritunl VPN instance. Null if VPN creation is disabled."
  value       = var.create_vpn ? module.vpn_server[0].vpn_name : null
}

output "vpn_zone" {
  description = "The zone of the Pritunl VPN instance. Null if VPN creation is disabled."
  value       = var.create_vpn ? module.vpn_server[0].vpn_zone : null
}

output "vpc_selflink" {
  description = "The URI (self-link) of the VPC network."
  value       = module.vpc.network_self_link
}

output "subnets" {
  value       = [for network in module.subnets.subnets : network.name]
  description = "List of Subnets created"
}