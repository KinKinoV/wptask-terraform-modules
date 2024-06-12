
# MUST BE APPLIED FIRST WITH "-target" FLAG!!!
# After you must change nameservers for your domain name in your domain registar
# Then continue creating all infrastructure
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

module "route53-records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.11.1"

  create = var.create_records

  zone_name = var.zone_name

  records = [
    {
      name  = "wordpress"
      type  = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    }
  ]

 # Encoded in json for Terragrunt
  # records_jsonencoded = [
  #   {
  #     name  = "wordpress"
  #     type  = "A"
  #     alias = {
  #       name    = module.cloudfront.cloudfront_distribution_domain_name
  #       zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
  #     }
  #   }
  # ]

  depends_on = [ module.hosted_zone, module.cloudfront ]
}