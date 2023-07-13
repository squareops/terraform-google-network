output "subnet_name" {
  value       = google_compute_subnetwork.subnetwork.name
  description = "The name of created subnet resources"
}

output "secondary_ip_range" {
  value       = google_compute_subnetwork.subnetwork.secondary_ip_range
  description = "The details of secondary ip range of subnet"
}
