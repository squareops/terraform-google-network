output "name" {
  description = "The name of the private subnet."
  value       = google_compute_subnetwork.private_subnet.name
}

output "secondary_ip_range" {
  description = "The secondary IP ranges of the private subnet."
  value       = google_compute_subnetwork.private_subnet.secondary_ip_range
}
output "private_ip_cidr" {
  description = "The IP ranges of the private subnet."
  value       = google_compute_subnetwork.private_subnet.ip_cidr_range
}
