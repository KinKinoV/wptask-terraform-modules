module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  name    = "${var.environment}-wordpress-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port = 443
      to_port = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4 = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"

  listeners = {
    http-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https-weighted-target = {
      port                        = 443
      protocol                    = "HTTPS"
      ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn             = module.acm.acm_certificate_arn
      additional_certificate_arns = [module.acm_wildcard.acm_certificate_arn]
      weighted_forward = {
        target_groups = [
          {
            target_group_key = "wordpress_instances"
            weight           = 60
          },
        ]
      }
    }
  }

  target_groups = {
    wordpress_instances = {
      name_prefix                       = "WP-TG"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_anomaly_mitigation = "on"
      load_balancing_cross_zone_enabled = false

      health_check = {
        enabled             = true
        interval            = 30
        path                = var.health_check_target
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version  = "HTTP1"
      create_attachment = false
    }
  }

  tags = local.tags
}