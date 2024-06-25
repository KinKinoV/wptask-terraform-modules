module "route53-records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.11.1"

  zone_name = var.zone_name

  records = [
    {
      name = "wordpress"
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    },
  ]

  depends_on = [module.cloudfront]
}

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.4.0"

  aliases = ["wordpress.${var.zone_name}"]

  comment             = "${var.environment} CloudFront for WordpPress"
  enabled             = true
  is_ipv6_enabled     = false
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  # Creating Origin Access Control so that CloudFront is able to serve static from bucket
  create_origin_access_control = true
  origin_access_control = {
    s3_wordpress_static = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  # Saving logs to separate s3 bucket
  logging_config = {
    bucket = module.cloudfront-logs.s3_bucket_bucket_domain_name
    prefix = "cloudfront"
  }

  origin = {
    wordpress-ALB = {
      domain_name = module.alb.dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }

    wordpress-static = {
      # Declaring domain in this way, because we need to create bukcet policy with
      # this CloudFront ARN
      domain_name           = "${var.environment}-${var.bucket_name}.s3.${var.region}.amazonaws.com"
      origin_access_control = "s3_wordpress_static"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "wordpress-ALB"
    viewer_protocol_policy = "redirect-to-https"

    # Allowing all methods so that WordPress works correctly 
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true

    use_forwarded_values = true

    headers = [
      "Origin",
      "Host",
      "CloudFront-Is-Tablet-Viewer",
      "CloudFront-Is-Mobile-Viewer",
      "CloudFront-Is-Desktop-Viewer",
      "CloudFront-Forwarded-Proto"
    ]
    query_string              = true
    cookies_forward           = "whitelist"
    cookies_whitelisted_names = ["comment_*", "wordpress_*", "wp-settings-*"]

    min_ttl     = 0
    default_ttl = 300
    max_ttl     = 31536000
  }

  ordered_cache_behavior = [
    # No cahing for admin and login pages
    {
      path_pattern           = "/wp-admin/*"
      target_origin_id       = "wordpress-ALB"
      viewer_protocol_policy = "redirect-to-https"
      compress               = true

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD", "OPTIONS"]

      use_forwarded_values = true

      headers = [
        "Origin",
        "Host",
        "CloudFront-Is-Tablet-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Forwarded-Proto"
      ]
      query_string    = true # Forward ALL
      cookies_forward = "all" # Forward ALL

      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 0
    },
    {
      path_pattern           = "/wp-login.php"
      target_origin_id       = "wordpress-ALB"
      viewer_protocol_policy = "redirect-to-https"
      compress               = true

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD", "OPTIONS"]

      use_forwarded_values = true

      headers = [
        "Origin",
        "Host",
        "CloudFront-Is-Tablet-Viewer",
        "CloudFront-Is-Mobile-Viewer",
        "CloudFront-Is-Desktop-Viewer",
        "CloudFront-Forwarded-Proto"
      ]
      query_string    = true # Forward ALL
      cookies_forward = "all" # Forward ALL

      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 0
    },
    # WordPress assets
    {
      path_pattern           = "/wp-includes/*"
      target_origin_id       = "wordpress-static"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD", "OPTIONS"]
      compress        = true

      use_forwarded_values = false

      cache_policy_name            = "Managed-CachingOptimized"
      origin_request_policy_name   = "Managed-CORS-S3Origin"
      response_headers_policy_name = "Managed-SimpleCORS"
    },
    {
      path_pattern           = "/wp-content/*"
      target_origin_id       = "wordpress-static"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD", "OPTIONS"]
      compress        = true

      use_forwarded_values = false

      cache_policy_name            = "Managed-CachingOptimized"
      origin_request_policy_name   = "Managed-CORS-S3Origin"
      response_headers_policy_name = "Managed-SimpleCORS"
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm_wildcard.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = local.tags

  depends_on = [module.alb, module.acm]
}