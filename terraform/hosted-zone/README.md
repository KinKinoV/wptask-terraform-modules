# Terraform Module "hosted-zone"

This terraform module creates Route 53 Hosted zone with required dns name for infrastructure where WordPress is being deployed.

## Inputs

|     Name    |   Type   | Required | Default value |                   Description                  |
|-------------|----------|----------|---------------|------------------------------------------------|
| environment | `string` | no       | dev           | Environment name for this deployment           |
| region      | `string` | no       | us-east-1     | Region where infrastructure should be deployed |
| zone_name   | `string` | yes      | -             | FQDN to use with Route53 hosted zone           |

## Outputs

|           Name          |                   Description                  |
|-------------------------|------------------------------------------------|
| zone_name               | Hosted Zone name                               |
| zone_id                 | Hosted Zone ID                                 |
| hosted_zone_nameservers | Name Servers for your hosted zone that should be used in your domain registar |

## Used Terraform modules

|      Name      |    Author    |                                                   Source                                                    | Version |
|----------------|--------------|-------------------------------------------------------------------------------------------------------------|---------|
| route53        | antonbabenko | [Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/route53/aws/2.11.1)        |  2.11.1 |
