output "hosted_zone_nameservers" {
  description = "Name Servers for your hosted zone that should be used in your domain registar"
  value       = module.hosted_zone.route53_zone_name_servers
}

output "bastion_dns_name" {
  description = "Public DNS name for Bastion instance"
  value       = module.bastion.public_dns
}

output "alb_dns_name" {
  description = "Public DNS name for ALB"
  value       = module.alb.dns_name
}

output "efs_dns_name" {
  description = "DNS name for EFS"
  value       = module.efs.dns_name
}