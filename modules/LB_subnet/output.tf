output "subnet_name" {
  description = "The name of the created subnet resources."
  value       = google_compute_subnetwork.LB_subnet[*].name
}

output "subnet_cidr" {
  description = "The IPv4 CIDR ranges for the created subnets."
  value       = google_compute_subnetwork.LB_subnet[*].ip_cidr_range
}
