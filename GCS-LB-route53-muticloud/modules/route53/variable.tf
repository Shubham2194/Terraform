variable "domain_name" {
  description = "The domain name to map to the load balancer IP"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "load_balancer_ip" {
  description = "The IP address of the load balancer"
  type        = string
}

variable "subdomain_name" {}