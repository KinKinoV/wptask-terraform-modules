output "zone_name" {
  description = "Hosted Zone name"
  value = var.zone_name
}

output "zone_id" {
  description = "Hosted Zone ID"
  value = module.hosted_zone.route53_zone_zone_id["${var.zone_name}"]
}

output "hosted_zone_nameservers" {
  description = "Name Servers for your hosted zone that should be used in your domain registar"
  value       = module.hosted_zone.route53_zone_name_servers
}