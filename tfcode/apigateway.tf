module "apigateway-v2" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 2.0.0"

  name                        = "counter-http-${random_pet.this.id}"
  domain_name                 = "counter.${var.AWS_DOMAIN_NAME}"
  domain_name_certificate_arn = module.acm-apigateway.acm_certificate_arn
  description                 = "Counter API"
  protocol_type               = "HTTP"
  default_route_settings = {
    detailed_metrics_enabled = false
    throttling_burst_limit   = 100
    throttling_rate_limit    = 100
  }
  #allow   Access-Control-Allow-Origin https://malbertini.ovh
  cors_configuration = {
    # allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    # allow_methods = ["*"]
    allow_origins = ["https://${var.AWS_DOMAIN_NAME}"]
  }

  integrations = {
    "GET /increment" = {
      lambda_arn             = module.counterlambda.lambda_function_arn
      payload_format_version = "2.0"
    }
  }
}

# resource "aws_apigatewayv2_api" "lambda" {
#   name          = "lambda_gw_api"
#   protocol_type = "HTTP"
#   cors_configuration {
#     allow_origins = ["https://www.mywebsite.fr"]
#     allow_methods = ["POST", "GET", "OPTIONS"]
#     allow_headers = ["content-type"]
#     max_age = 300
#   }
# }
