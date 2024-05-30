variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
variable "repository_name" {
  default = "prod"
}

variable "tags" {
  default = "prod"
}
