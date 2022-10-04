module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.6.0"
  zones = {
    "${var.AWS_DOMAIN_NAME}" = {
      comment = "My awesome Zone"
    }
  }
}
module "records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  version   = "~> 2.0"
  zone_name = var.AWS_DOMAIN_NAME
  records = [
    {
      name = ""
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    },
  ]
}
module "acm" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> 3.0"
  domain_name = var.AWS_DOMAIN_NAME
  zone_id     = local.zone_id
  providers = {
    aws = aws.us-east-1
  }
}

module "records-apigateway" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  version   = "~> 2.0"
  zone_name = var.AWS_DOMAIN_NAME
  records = [
    {
      name = "counter"
      type = "A"
      alias = {
        name                   = module.apigateway-v2.apigatewayv2_domain_name_configuration[0].target_domain_name
        zone_id                = module.apigateway-v2.apigatewayv2_domain_name_configuration[0].hosted_zone_id
        evaluate_target_health = false
      }
    },
  ]
}

module "acm-apigateway" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "~> 3.0"
  domain_name = "counter.${var.AWS_DOMAIN_NAME}"
  zone_id     = local.zone_id
}
