terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.52.0"
    }
  }
}

locals {
  tags = {
    Environment = var.environment
    Terraform   = true
  }
}