variable "AWS_REGION" {}
variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "AWS_BUCKET" {}
variable "AWS_DOMAIN_NAME" {}
variable "COUNTAPI" {}
variable "INFRACOST_API_KEY" {}
variable "SONAR_TOKEN" {}
variable "OWNER" {
  type = string
}
variable "GITHUB_TOKEN" {}

variable "cache_policy_name" {
  default = "Managed-CachingOptimized"
}

locals {
  zone_id = module.zones.route53_zone_zone_id[var.AWS_DOMAIN_NAME]
}
