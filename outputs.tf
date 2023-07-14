output "region" {
  description = "The region where the VPC is located."
  value       = var.region
}

output "network" {
  value       = google_compute_network.network
  description = "The VPC resource being created"
}

output "network_name" {
  value       = google_compute_network.network.name
  description = "The name of the VPC being created"
}

output "network_id" {
  value       = google_compute_network.network.id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.network.self_link
  description = "The URI of the VPC being created"
}

output "vpn_name" {
  description = "The name of the Pritunl VPN instance. Null if VPN creation is disabled."
  value       = var.create_vpn ? module.vpn_server[0].vpn_name : null
}

output "vpn_zone" {
  description = "The zone of the Pritunl VPN instance. Null if VPN creation is disabled."
  value       = var.create_vpn ? module.vpn_server[0].vpn_zone : null
}

output "subnet_name" {
  value       = module.subnets.subnet_name
  description = "List of Subnets created"
}

output "secondary_ip_range" {
  value       = module.subnets.secondary_ip_range
  description = "The details of secondary ip range of subnet"
}
