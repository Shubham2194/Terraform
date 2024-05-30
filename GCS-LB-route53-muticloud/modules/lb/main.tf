resource "google_compute_backend_bucket" "default" {
  name       = var.bucket_name
  bucket_name = var.bucket_name
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = var.ssl_certificate_name

  managed {
    domains = [var.subdomain_name]
  }
}

resource "google_compute_url_map" "default" {
  name            = var.url_map_name
  default_service = google_compute_backend_bucket.default.self_link
}

resource "google_compute_target_https_proxy" "default" {
  name             = var.target_proxy_name
  url_map          = google_compute_url_map.default.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = var.forwarding_rule_name
  target     = google_compute_target_https_proxy.default.self_link
  port_range = "443"
}

output "ip_address" {
  value = google_compute_global_forwarding_rule.default.ip_address
}



