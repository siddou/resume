resource "aws_cloudwatch_log_group" "counter-lambda" {
  name              = "/aws/lambda/counter-lambda-${random_pet.this.id}"
  retention_in_days = 90
}
data "aws_caller_identity" "current" {}
module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 3.3.1"

  publish       = true
  function_name = "counter-lambda-${random_pet.this.id}"
  handler       = "index.lambda_handler"
  runtime       = "python3.9"
  depends_on = [
    aws_cloudwatch_log_group.counter-lambda,
  ]
  use_existing_cloudwatch_log_group = true
  source_path = [
    "./src/get_viewcount/index.py",
  ]
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.apigateway-v2.apigatewayv2_api_execution_arn}/api/*"
    }
  }
  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect = "Allow",
      actions = [
        "dynamodb:GetItem",
        "dynamodb:UpdateItem"
      ],
      resources = [module.dynamodb-table.dynamodb_table_arn]
    },
  }

}
