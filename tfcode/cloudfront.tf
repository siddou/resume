data "aws_cloudfront_cache_policy" "cache_policy" {
  name = var.cache_policy_name
}
resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name    = "SecurityHeadersPolicy-Aplus-2022"
  comment = "add security_header"
  security_headers_config {
    strict_transport_security {
      override                   = false
      access_control_max_age_sec = 31536000
    }
    xss_protection {
      override   = false
      mode_block = true
      protection = true
    }
    content_type_options {
      override = true
    }
    frame_options {
      override     = false
      frame_option = "SAMEORIGIN"
    }
    referrer_policy {
      override        = false
      referrer_policy = "strict-origin-when-cross-origin"
    }
    content_security_policy {
      override                = false
      content_security_policy = "upgrade-insecure-requests;"
    }
  }
  custom_headers_config {
    items {
      override = false
      header   = "permissions-policy"
      value    = "battery=(), camera=(), geolocation=(), microphone=()"
    }
    items {
      override = true
      header   = "server"
      value    = "null"
    }
  }
}
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = module.s3-bucket.s3_bucket_bucket_regional_domain_name
  description                       = ""
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.0.0"
  providers = {
    aws = aws.us-east-1
  }
  aliases                        = [var.AWS_DOMAIN_NAME]
  comment                        = "My awesome CloudFront"
  enabled                        = true
  price_class                    = "PriceClass_100"
  retain_on_delete               = false
  wait_for_deployment            = false
  is_ipv6_enabled                = false
  default_root_object            = "index.html"
  create_monitoring_subscription = false
  http_version                   = "http2and3"

  origin = {
    s3_one = {
      domain_name              = module.s3-bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    }
  }

  default_cache_behavior = {
    target_origin_id           = "s3_one"
    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    use_forwarded_values       = false
    cache_policy_id            = data.aws_cloudfront_cache_policy.cache_policy.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers_policy.id
  }
  viewer_certificate = {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  geo_restriction = {
    restriction_type = "blacklist"
    locations        = ["CU", "IR", "KP", "SY", "RU", "BY"]
  }
}

