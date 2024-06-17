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

# REQUIRED
variable "public_key_wp" {
  description = "Public Key for WordPress instances in private subnets"
  type        = string
}

# REQUIRED
variable "vpc_azs" {
  description = "List of availability zones where VPC subnets were created ('vpc_azs' output from main-infra module)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]

  validation {
    condition     = length(var.vpc_azs) >= 2
    error_message = "Incorrect list of AZs, check if list contains at least two AZs."
  }
}

# REQUIRED
variable "wp_subnets" {
  description = "List of private subnets where WordPress instances must be deployed ('private_subnets' output from main-infra module)"
  type = list(string)
}

# REQUIRED
variable "alb_tg_arn" {
  description = "ARN of the Target Group to which Autoscaling group must be attached ('target_group_arn' output from main-infra module)"
  type = string
}

# REQUIRED
variable "wordpress_ami" {
  description = "ID of the AMI ready to be used in Launch Template for Autoscaling group"
  type = string
}

# REQUIRED
variable "wp_sg_ids" {
  description = "List of security groups for WordPress instances in AUtoscaling group ('wordpress_sg' output from main-infra module)"
  type = list(string)
}

# REQUIRED
variable "efs_id" {
  description = "ID of the EFS with WordPress shared data"
  type = string
}

variable "instance_type" {
  description = "Type of instance to use for deployment"
  type = string
  default = "t3.micro"
}