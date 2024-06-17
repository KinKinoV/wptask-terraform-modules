#######################################################################################
#                                       Network                                       #
#######################################################################################

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
    error_message = "Incorrect list of AZs, check if list contains at least two AZs."
  }
}

# REQUIRED
variable "allowed_bastion_ips" {
  description = "List of IPs that are allowed to SSH into bastion host"
  type        = list(string)
}

# REQUIRED 
variable "zone_name" {
  description = "FQDN to use with Route53 hosted zone ('zone_name' output from hosted-zone module)"
  type        = string
}

# REQUIRED 
variable "hosted_zone_id" {
  description = "ID of the Route53 hosted zone ('zone_id' output from hosted-zone module)"
  type = string
}

variable "health_check_target" {
  description = "Path through which Target Group will check WP instances' health"
  type = string
  default = "/index.php"
}

#######################################################################################
#                                       Storage                                       #
#######################################################################################

variable "bucket_name" {
  description = "Name for the S3 static bucket"
  type = string
  default = "wp-static-bucket"
}

#######################################################################################
#                                      Database                                       #
#######################################################################################

# REQUIRED
variable "db_password" {
  description = "Password for WordPress database in MySQL"
  type = string
}

variable "rds_monitoring_role_arn" {
  description = "Enter RDS monitoring role ARN if it already exists in AWS IAM"
  type        = string
  default     = null
}

#######################################################################################
#                                      Bastion                                        #
#######################################################################################

variable "public_key_bastion" {
  description = "Public Key for Bastion instance in public subnet"
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