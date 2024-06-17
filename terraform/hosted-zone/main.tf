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

module "hosted_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "2.11.1"

  zones = {
    "${var.zone_name}" = {
      comment = "Hosted zone for WordPress domain names"
      tags = {
        Terraform   = true
        Environment = var.environment
        Name        = "${var.zone_name}"
      }
    }
  }

  tags = local.tags
}