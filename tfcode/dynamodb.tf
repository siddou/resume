module "dynamodb-table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 2.0.0"

  name                = "cloud-resume-stats"
  billing_mode        = "PROVISIONED"
  read_capacity       = 1
  write_capacity      = 1
  autoscaling_enabled = false
  hash_key            = "stat"
  attributes = [
    {
      name = "stat"
      type = "S"
    },
  ]
}

# resource "aws_dynamodb_table_item" "view-count" {
#   table_name = module.dynamodb-table.dynamodb_table_id
#   hash_key   = "stat"
#   item       = <<ITEM
# {
#   "stat": {"S": "view-count"},
#   "Quantity": {"N": "0"}
# }
# ITEM
# }
