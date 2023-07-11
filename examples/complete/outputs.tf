output "vpc_name" {
  description = "The name of the VPC network."
  value       = module.vpc.vpc_name
}

output "subnets" {
  value       = module.vpc.subnets
  description = "List of Subnets created"
}
