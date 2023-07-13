output "vpc_name" {
  description = "The name of the VPC network."
  value       = module.vpc.network_name
}

output "subnet_name" {
  value       = module.vpc.subnet_name
  description = "List of Subnets created"
}

output "secondary_ip_range" {
  value       = module.vpc.secondary_ip_range
  description = "The details of secondary ip range of subnet"
}
