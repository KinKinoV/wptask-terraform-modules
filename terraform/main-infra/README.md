# Terraform Module "main-infra"

This terraform module creates next resources in AWS: 
1. VPC 
2. Subnets
3. Security Groups
4. Application Load Balancer
5. CloudFront
6. S3 buckets
7. EFS and Multi-AZ RDS MySQL database
8. Bastion host (EC2 Instance)

All these resources are configured to support hosting WordPress application in EC2 Autoscalling Group.

## Inputs

|           Name          |       Type      | Required |                Default value               |                                    Description                                     |
|-------------------------|-----------------|----------|--------------------------------------------|------------------------------------------------------------------------------------|
| vpc_cidr                | `string`        | no       | "100.100.0.0/16"                           | CIDR of the VPC for this project                                                   |
| vpc_azs                 | `list(string)`  | no       | ["us-east-1a", "us-east-1b", "us-east-1c"] | List of availability zones where subnets should be created                         |
| allowed_bastion_ips     | `list(string)`  | yes      | -                                          | List of IPs that are allowed to SSH into bastion host                              |
| zone_name               | `string`        | yes      | -                                          | FQDN to use with Route53 hosted zone ('zone_name' output from hosted-zone module)  |
| hosted_zone_id          | `string`        | yes      | -                                          | ID of the Route53 hosted zone ('zone_id' output from hosted-zone module)           |
| health_check_target     | `string`        | no       | "/index.php"                               | Path through which Target Group will check WP instances' health                    |
| bucket_name             | `string`        | no       | "wp-static-bucket"                         | Name for the S3 static bucket                                                      |
| db_password             | `string`        | yes      | -                                          | Password for WordPress database in MySQL                                           |
| public_key_bastion      | `string`        | yes      | -                                          | Public Key for Bastion instance in public subnet                                   |
| environment             | `string`        | no       | "dev"                                      | Environment name for this deployment                                               |
| region                  | `string`        | no       | "us-east-1"                                | Region where infrastructure should be deployed                                     |

## Outputs

|        Name       |                             Description                           |
|-------------------|-------------------------------------------------------------------|
| vpc_azs           | List of AZs where VPC created subnets                             |
| private_subnets   | List of private subnets cretaed in VPC                            |
| target_group_arn  | ARN of the Target Group for WordPress instances from created ALB  |
| wordpress_sg      | ID of the security group for WordPress instances                  |
| efs_dns_name      | DNS name for EFS                                                  |
| bastion_dns_name  | Public DNS name for Bastion host                                  |

## Used Terraform modules

|      Name      |    Author    |                                                   Source                                                    | Version |
|----------------|--------------|-------------------------------------------------------------------------------------------------------------|---------|
| vpc            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.8.1)             |  5.8.1  |
| security-group | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/5.1.2)  |  5.1.2  |
| acm            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/kms/aws/4.5.0)             |  4.5.0  |
| alb            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/9.9.0)             |  9.9.0  |
| route53        | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/route53/aws/2.11.1)        |  2.11.1 |
| cloudfront     | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/cloudfront/aws/3.4.0)      |  3.4.0  |
| s3-bucket      | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/4.1.2)       |  4.1.2  |
| efs            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/1.6.3)             |  1.6.3  |
| rds            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/6.6.0)             |  6.6.0  |
| ec2-instance   | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/5.6.1)    |  5.6.1  |
