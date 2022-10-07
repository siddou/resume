module "apigateway-v2" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 2.0.0"

  name                        = "counter-http-${random_pet.this.id}"
  domain_name                 = "counter.${var.AWS_DOMAIN_NAME}"
  domain_name_certificate_arn = module.acm-apigateway.acm_certificate_arn
  description                 = "Counter API"
  protocol_type               = "HTTP"

  # body = templatefile("./src/swagger.yml", {
  #   function_arn = module.lambda.lambda_function_arn
  # })

  default_route_settings = {
    detailed_metrics_enabled = false
    throttling_burst_limit   = 100
    throttling_rate_limit    = 200
  }

  integrations = {
    # "GET /${module.lambda.lambda_function_name}" = {
    #   lambda_arn             = module.lambda.lambda_function_arn
    #   payload_format_version = "2.0"
    # }
    "GET /increment" = {
      lambda_arn             = module.lambda.lambda_function_arn
      payload_format_version = "2.0"
    }
    "ANY /error" = {
      lambda_arn             = module.lambda.lambda_function_arn
      payload_format_version = "2.0"
    }
  }
}


