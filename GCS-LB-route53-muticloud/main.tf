module "gcs_bucket" {
  source      = "./modules/gcs"
  bucket_name = var.bucket_name
  location    = var.google_region
}

module "load_balancer" {
  source               = "./modules/lb"
  bucket_name          = module.gcs_bucket.bucket_name
  ssl_certificate_name = var.ssl_certificate_name
  domain_name          = var.domain_name
  url_map_name         = var.url_map_name
  target_proxy_name    = var.target_proxy_name
  forwarding_rule_name = var.forwarding_rule_name
  google_region        = var.google_region
  subdomain_name       = var.subdomain_name
}

module "aws_route53" {
  source           = "./modules/route53"
  domain_name      = var.domain_name
  aws_region       = var.aws_region
  load_balancer_ip = module.load_balancer.ip_address
  subdomain_name   = var.subdomain_name
}
