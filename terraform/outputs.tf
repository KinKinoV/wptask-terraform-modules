output "hosted_zone_nameservers" {
  description = "Name Servers for your hosted zone that should be used in your domain registar"
  value = module.hosted_zone.route53_zone_name_servers
}