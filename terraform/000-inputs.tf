#############################################################################
#                             REQUIRED VARIABLES                            #
#############################################################################

variable "public_key_bastion" {
  description = "Public Key for Bastion instance in public subnet"
  type        = string
}

variable "public_key_wp" {
  description = "Public Key for wordpress instances in private subnets"
  type        = string
}

variable "allowed_bastion_ips" {
  description = "List of IPs that are allowed to SSH into bastion host"
  type        = list(string)
}

variable "rds_monitoring_role_arn" {
  description = "RDS monitoring role ARN if it already exists in AWS IAM"
  type        = string
}

variable "zone_name" {
  description = "FQDN to use with Route53 hosted zone"
  type        = string
}

variable "db_password" {
  description = "Password for MySQL database"
  type        = string
}

#######################################################################################
#                                  Other variables                                    #
#######################################################################################

variable "environment" {
  description = "Environment name for this deployment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Region where infrastructure should be deployed"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR of the VPC for this project"
  type        = string
  default     = "100.100.0.0/16"
}

variable "vpc_azs" {
  description = "List of availability zones where subnets should be created"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]

  validation {
    condition     = length(var.vpc_azs) >= 2
    error_message = "Incorrect list of AZs, check if list contains at least three AZs."
  }
}

variable "bucket_name" {
  description = "Name for the bucket that will host WordPress static files"
  type        = string
  default     = "wp-static-bucket"
}

variable "instance_type" {
  description = "Instance type to use for Autoscalling launch template"
  type        = string
  default     = "t3.micro"
}

variable "health_check_target" {
  description = "Path on which ALB will check WordPress instance health"
  type        = string
  default     = "/index.php"
}