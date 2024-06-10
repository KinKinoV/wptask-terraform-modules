# How to use

## Creation
To correctly deploy infrastrucuture you need to follow specific order in applying resources:
1. Create `.tfvars` file with all required variables 
2. Create Route53 Hosted Zone using 
```bash
terraform apply -target="module.hosted_zone" --var-file=/path/to/yours.tfvars
```
3. After hosted zone was successfully created you should go to your domain registar (namecheap, nic, godaddy, etc.) and change nameservers to the ones provided in hosted zone (also should be visible in outputs)
4. Now you can apply rest of the infrastructure using 
```bash
terraform apply --var-file=/path/to/yours.tfvars
```
5. After infrastructure finishes creating you should use 
```bash
terraform apply -target="module.route53-records" -var="create_records=true"
```
This will create record in Route53 hosted zone to your cloudfront from which common users will connect to WordPress site.

## Destroying infrastructure

To destroy all of the created infrastructure use:
```bash
terraform destroy --var-file=/path/to/yours.tfvars
```

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
| kms            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/kms/aws/3.0.0)             |  3.0.0  |
| acm            | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/kms/aws/4.5.0)             |  4.5.0  |
