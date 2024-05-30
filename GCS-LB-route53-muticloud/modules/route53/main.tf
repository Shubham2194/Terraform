data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "lb_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.subdomain_name
  type    = "A"
  ttl     = 300

  records = [var.load_balancer_ip]
}

output "record" {
  value = aws_route53_record.lb_record.fqdn
}



