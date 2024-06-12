########################
# Supporting resources #
########################

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
}

resource "aws_key_pair" "bastion" {
  key_name = "${var.environment}-wp-bastion"
  public_key = var.public_key_bastion
}

resource "aws_key_pair" "wp-instances" {
  key_name = "${var.environment}-wp-instances"
  public_key = var.public_key_wp
}

######################
# Required Instances #
######################

module "wordpress-hosts" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "7.6.0"

  # Autoscaling
  name = "${var.environment}-wordpress"
  use_name_prefix = false
  instance_name = "${var.environment}-wp-instance"

  min_size = length(var.vpc_azs)
  max_size = length(var.vpc_azs) * 2
  vpc_zone_identifier = module.vpc.private_subnets

  create_traffic_source_attachment = true
  traffic_source_identifier        = module.alb.target_groups["wordpress_instances"].arn
  traffic_source_type              = "elbv2"

  # Launch Tempalte
  image_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  # user_data = base64encode()
  instance_market_options = {
    market_type = "spot"
  }
  network_interfaces = [ 
    {
      delete_on_termination = true
      description = "eth0"
      device_index = 0
      security_groups = [ "${module.wordpress-sg.security_group_id}" ]
      delete_on_termination = true
    },
  ]

  scaling_policies = {
    avg-cpu-gt-60 = {
      policy_type = "TargetTrackingScaling"
      estimated_instance_warmup = 300
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
      }
    }
  }

  tags = local.tags
}

module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name = "${var.environment}-bastion"

  instance_type = "t3.micro"
  key_name = aws_key_pair.bastion.key_name
  subnet_id = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.bastion-sg.security_group_id]
  associate_public_ip_address = true

  tags = local.tags
}