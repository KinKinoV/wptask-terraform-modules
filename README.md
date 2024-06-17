# How to use

## Creation
To correctly deploy infrastrucuture you need to follow specific order in applying resources:

1. Apply [hosted-zone](/terraform/hosted-zone/) module
2. Prepare your own or use already pre-built AMI image for hosting WordPress application
3. Apply [main-infra](/terraform/main-infra/) module, passing all required outputs from `hosted-zone` module
4. Apply [wordpress-instances](/terraform/wordpress-instances/) module, passing all required outputs from `main-infra` module (don't forget to use WordPress AMI in `wordpress_ami` input)

To apply infrastructure you can use next command in corresponding module directory:
```bash
terraform apply --var-file=/path/to/yours.tfvars
```

## Destroying infrastructure

To destroy all of the created infrastructure, you must apply this command:
```bash
terraform destroy --var-file=/path/to/yours.tfvars
```
In each module corresponding directory in reverse order:
1. `wordpress-instances`
2. `main-infra`
3. `hosted-zone`

# Used Terraform modules

|      Name      |    Author    |                                                   Source                                                    | Version |
|----------------|--------------|-------------------------------------------------------------------------------------------------------------|---------|
| vpc            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.8.1)             |  5.8.1  |
| s3-bucket      | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/4.1.2)       |  4.1.2  |
| security-group | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/5.1.2)  |  5.1.2  |
| autoscaling    | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/7.6.0)     |  7.6.0  |
| ec2-instance   | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/5.6.1)    |  5.6.1  |
| rds            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/6.6.0)             |  6.6.0  |
| efs            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/1.6.3)             |  1.6.3  |
| cloudfront     | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/cloudfront/aws/3.4.0)      |  3.4.0  |
| alb            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/9.9.0)             |  9.9.0  |
| route53        | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/route53/aws/2.11.1)        |  2.11.1 |
| acm            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/kms/aws/4.5.0)             |  4.5.0  |
