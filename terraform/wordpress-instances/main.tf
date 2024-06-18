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

  user_data = <<EOF
#!/bin/bash
sudo mount -t efs -o tls ${var.efs_id}:/ /var/www/html/
  EOF
}

resource "aws_key_pair" "wp-instances" {
  key_name   = "${var.environment}-wp-instances"
  public_key = var.public_key_wp
}

module "wordpress-hosts" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "7.6.0"

  # Autoscaling
  name            = "${var.environment}-wordpress"
  use_name_prefix = false
  instance_name   = "${var.environment}-wp-instance"

  min_size            = length(var.vpc_azs)
  max_size            = length(var.vpc_azs) * 2
  vpc_zone_identifier = var.wp_subnets

  create_traffic_source_attachment = true
  traffic_source_identifier        = var.alb_tg_arn
  traffic_source_type              = "elbv2"

  scaling_policies = {
    avg-cpu-gt-60 = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 300
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
      }
    }
  }

  # Launch Tempalte
  image_id      = var.wordpress_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.wp-instances.key_name
  user_data     = base64encode(local.user_data)
  instance_market_options = {
    market_type = "spot"
  }
  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = var.wp_sg_ids
      delete_on_termination = true
    },
  ]

  tags = local.tags
}