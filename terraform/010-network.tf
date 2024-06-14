###################
# VPC and Subnets #
###################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${var.environment}-wordpress-project"
  cidr = var.vpc_cidr

  azs              = var.vpc_azs
  public_subnets   = [for k, v in var.vpc_azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in var.vpc_azs : cidrsubnet(var.vpc_cidr, 8, k + 20)]
  database_subnets = [for k, v in var.vpc_azs : cidrsubnet(var.vpc_cidr, 8, k + 40)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  create_database_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}

###################
# Security Groups #
###################

module "bastion-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "${var.environment}-bastion-sg"
  description = "Security Group for Bastion instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.allowed_bastion_ips
  ingress_rules       = ["ssh-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.tags
}

module "wordpress-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "${var.environment}-wordpress-instances-sg"
  description = "Security Group for WordPress instances in private network"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    # Allow SSH connection from Bastion instance
    {
      rule = "ssh-tcp"
      cidr_blocks = "${module.bastion.private_ip}/32"
    },
   ]

  # Allows HTTP/HTTPS traffic from ALB
  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb.security_group_id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = module.alb.security_group_id
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.tags

  depends_on = [module.alb]
}

module "db-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "${var.environment}-wordpress-database"
  description = "Security Group for Multi-AZ RDS"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}