######################################
# S3 Buckets with required resources #
######################################

module "s3-static" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket        = "${var.environment}-${var.bucket_name}"
  force_destroy = true

  tags = local.tags
}

module "s3-logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket        = "${var.environment}-wptask-project-logs"
  force_destroy = true

  control_object_ownership = true

  attach_elb_log_delivery_policy        = true
  attach_lb_log_delivery_policy         = true
  attach_access_log_delivery_policy     = true
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  tags = local.tags
}

data "aws_caller_identity" "current" {}

data "aws_canonical_user_id" "current" {}

data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

module "cloudfront-logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket        = "${var.environment}-wptask-cloudfront-logs"
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  grant = [{
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_canonical_user_id.current.id
    }, {
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
    }
  ]

  owner = {
    id = data.aws_canonical_user_id.current.id
  }
}

###############################
# EFS with required resources #
###############################

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.3"

  name           = "${var.environment}-wp-storage"
  creation_token = "${var.environment}-wp-storage"
  encrypted      = false

  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }

  # attach_policy = true
  # bypass_policy_lockout_safety_check = false
  # policy_statements = [
  #     {
  #         sid = ""
  #         actions = ["elasticfilesystem:ClientMount"]
  #         principals = [
  #             {
  #                 type = "AWS"
  #                 identifiers = [ "iam_arn" ]
  #             }    
  #         ]
  #     }    
  # ]

  mount_targets         = { for k, v in zipmap(var.vpc_azs, module.vpc.private_subnets) : k => { subnet_id = v } }
  create_security_group = true
  security_group_vpc_id = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      description = "SG for EFS mount targets"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  access_points = {
    posix = {
      name = "wp-vm"
      posix_user = {
        gid = 1001
        uid = 1001
      }
    }
  }

  tags = local.tags
}