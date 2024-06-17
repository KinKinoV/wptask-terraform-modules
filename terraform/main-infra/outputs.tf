output "vpc_azs" {
  description = "List of AZs where VPC created subnets"
  value = module.vpc.azs
}

output "private_subnets" {
  description = "List of private subnets cretaed in VPC"
  value = module.vpc.private_subnets
}

output "target_group_arn" {
  description = "ARN of the Target Group for WordPress instances from created ALB"
  value = module.alb.target_groups["wordpress_instances"].arn
}

output "wordpress_sg" {
  description = "ID of the security group for WordPress instances"
  value = ["${module.wordpress-sg.security_group_id}"]
}

output "efs_dns_name" {
  description = "DNS name for EFS"
  value = module.efs.dns_name
}

output "bastion_dns_name" {
  description = "Public DNS name for Bastion host"
  value = module.bastion.public_dns
}