########################
# Supporting Resources #
########################

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.5.0"

  domain_name = var.zone_name
  zone_id = module.hosted_zone.route53_zone_zone_id["${var.zone_name}"]

  subject_alternative_names = [
    "*.${var.zone_name}"
  ]

  wait_for_validation = true

  tags = local.tags
}

##############
# Cloudfront #
##############

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.4.0"

  aliases = [ "wordpress.${var.zone_name}" ]

  comment = "${var.environment} CloudFront for WordpPress"
  enabled = true
  is_ipv6_enabled = false
  price_class = "PriceClass_All"
  retain_on_delete = false
  wait_for_deployment = false
  
  create_origin_access_identity = true
  origin_access_identities = {
    s3_wordpress_static = "${var.environment} CloudFront for WordpPress can access"
  }
  
  logging_config = {
    bucket = module.cloudfront-logs.s3_bucket_bucket_domain_name
  }

  origin = {
    wordpress-ALB = {
      domain_name = module.alb.dns_name
      custom_origin_config = {
        http_port = 80
        https_port = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    wordpress-static = {
      domain_name = module.s3-static.s3_bucket_bucket_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_wordpress_static"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id           = "wordpress-ALB"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "wordpress-static"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }


  tags = local.tags
  
  depends_on = [ module.s3-static, module.alb ]
}