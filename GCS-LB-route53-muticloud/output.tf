output "bucket_name" {
  value = module.gcs_bucket.bucket_name
}

output "load_balancer_ip" {
  value = module.load_balancer.ip_address
}

output "route53_record" {
  value = module.aws_route53.record
}
