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

# REQUIRED!
variable "zone_name" {
  description = "FQDN to use with Route53 hosted zone"
  type        = string
}