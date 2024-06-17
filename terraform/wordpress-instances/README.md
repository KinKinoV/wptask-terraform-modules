# Terraform Module "wordpress-instances"

This modules creates Autoscaling Group for WordPress instances that will automatically mount EFS on each new instance. Also this modules creates all required dependant resources.

## Inputs

|           Name          |       Type      | Required |Default value|                                                      Description                                                       |
|-------------------------|-----------------|----------|-------------|------------------------------------------------------------------------------------------------------------------------|
| environment             | `string`        | no       | "dev"       | Environment name for this deployment                                                                                   |
| region                  | `string`        | no       | "us-east-1" | Region where infrastructure should be deployed                                                                         |
| public_key_wp           | `string`        | yes      | -           | Public Key for WordPress instances in private subnets                                                                  |
| vpc_azs                 | `list(string)`  | yes      | -           | List of availability zones where VPC subnets were created ('vpc_azs' output from main-infra module)                    |
| wp_subnets              | `list(string)`  | yes      | -           | List of private subnets where WordPress instances must be deployed ('private_subnets' output from main-infra module)   |
| alb_tg_arn              | `string`        | yes      | -           | ARN of the Target Group to which Autoscaling group must be attached ('target_group_arn' output from main-infra module) |
| wordpress_ami           | `string`        | yes      | -           | ID of the AMI ready to be used in Launch Template for Autoscaling group                                                |
| wp_sg_ids               | `list(string)`  | yes      | -           | List of security groups for WordPress instances in AUtoscaling group ('wordpress_sg' output from main-infra module)    |
| efs_id                  | `string`        | yes      | -           | ID of the EFS with WordPress shared data                                                                               |
| instance_type           | `string`        | no       | "t3.micro"  | Type of instance to use for deployment                                                                                 |

## Outputs

This module doesn't have any outputs.

## Terraform Modules used

|      Name      |    Author    |                                                   Source                                                    | Version |
|----------------|--------------|-------------------------------------------------------------------------------------------------------------|---------|
| autoscaling    | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/7.6.0)     |  7.6.0  |
