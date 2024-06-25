###################################################################################
#                                    Network                                      # 
###################################################################################

output "vpc_azs" {
  description = "List of AZs where VPC created subnets"
  value       = module.vpc.azs
}

output "private_subnets" {
  description = "List of private subnets cretaed in VPC"
  value       = module.vpc.private_subnets
}

output "target_group_arn" {
  description = "ARN of the Target Group for WordPress instances from created ALB"
  value       = module.alb.target_groups["wordpress_instances"].arn
}

output "wordpress_sg" {
  description = "ID of the security group for WordPress instances"
  value       = ["${module.wordpress-sg.security_group_id}"]
}

output "efs_dns_name" {
  description = "DNS name for EFS"
  value       = module.efs.dns_name
}

output "bastion_dns_name" {
  description = "Public DNS name for Bastion host"
  value       = module.bastion.public_dns
}

output "cloudfront_dns_id" {
  description = "First part of the cloudfront DNS name"
  value = split(".", module.cloudfront.cloudfront_distribution_domain_name)[0]
}

###################################################################################
#                                       IAM                                       #
###################################################################################

output "w3tc_user_access_key_id" {
  description = "ID of the Access Key for W3TC WordPress plugin"
  value       = module.w3tc-user.iam_access_key_id
}

output "w3tc_user_access_key_secret" {
  description = "Secret of the Access Key for W3TC WordPress plugin"
  value       = module.w3tc-user.iam_access_key_secret
}

###################################################################################
#                                    Storage                                      #
###################################################################################

output "bucket_name" {
  description = "Name of the S3 bukcet that stores static assets"
  value       = module.s3-static.s3_bucket_id
}

###################################################################################
#                                    Database                                     #
###################################################################################

output "db_name" {
  description = "Name of the created Database"
  value       = module.my-sql-rds.db_instance_name
}

output "db_login" {
  description = "Login to use while connecting to DB"
  value       = module.my-sql-rds.db_instance_username
}

output "db_password" {
  description = "Password to use while connecting to DB"
  value       = var.db_password
  sensitive   = true
}

output "db_host" {
  description = "DNS address for Database"
  value       = module.my-sql-rds.db_instance_endpoint
}