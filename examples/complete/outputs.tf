output "vpc_name" {
  description = "The name of the VPC network."
  value       = module.vpc.vpc_details
}

output "public_subnet_details" {
  description = "Details of all public subnets created, including their names and CIDR ranges."
  value = [
    for subnet in module.vpc.public_subnet_details : {
      name = subnet.name
      cidr = subnet.cidr
    }
  ]
}

output "private_subnet_details" {
  description = "Details of all private subnets created, including their names, CIDR ranges, and secondary IP ranges."
  value = [
    for subnet in module.vpc.private_subnet_details : {
      name               = subnet.name
      private_ip_cidr    = subnet.private_ip_cidr
      secondary_ip_range = subnet.secondary_ip_range
    }
  ]
}

output "lb_subnet_details" {
  description = "Details of LB subent created, including their names and CIDR ranges."
  value = [
    for subnet in module.vpc.lb_subnet_details : {
      name = subnet.name
      cidr = subnet.cidr
    }
  ]
}

# output "lb_subnet_details" {
#   description = "Details of LB subent created, including their names and CIDR ranges."
#   value = [
#     for subnet in module.vpc.lb_subnet_details : {
#       name = subnet.subnet_name
#       cidr = subnet.subnet_cidr
#       # secondary_ip_range = subnet.secondary_ip_range
#     }
#   ]
# }
