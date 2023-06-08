output "region" {
  description = "The region where the VPC is located."
  value       = var.region
}

output "vpc_name" {
  description = "The name of the VPC network."
  value       = module.vpc.network_name
}

output "public_subnet" {
  description = "The public subnet name in the VPC."
  value       = format("%s-%s-public-subnet", var.name, var.environment)
}

output "private_subnet" {
  description = "The private subnet name in the VPC. Null if NAT gateway is disabled."
  value       = var.enable_nat_gateway ? format("%s-%s-private-subnet", var.name, var.environment) : null
}

output "public_subnet" {
  description = "The second public subnet name in the VPC. Null if NAT gateway is enabled."
  value       = var.enable_nat_gateway ? null : format("%s-%s-public-subnet-2", var.name, var.environment)
}

output "vpn_name" {
  description = "The name of the Pritunl VPN instance. Null if VPN creation is disabled."
  value       = var.create_vpn ? resource.google_compute_instance.default.*.name : null
}

output "vpn_zone" {
  description = "The zone of the Pritunl VPN instance. Null if VPN creation is disabled."
  value       = var.create_vpn ? resource.google_compute_instance.default.*.zone : null
}

output "vpc_selflink" {
  description = "The URI (self-link) of the VPC network."
  value       = module.vpc.network_self_link
}

output "subnets_secondary_ranges" {
  description = "The secondary IP ranges associated with the VPC subnets."
  value       = module.vpc.subnets_secondary_ranges
}
