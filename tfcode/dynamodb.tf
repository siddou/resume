module "dynamodb-table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 2.0.0"

  name                           = "cloud-resume-stats"
  billing_mode                   = "PROVISIONED"
  read_capacity                  = 1
  write_capacity                 = 1
  autoscaling_enabled            = false
  hash_key                       = "stat"
  server_side_encryption_enabled = true
  attributes = [
    {
      name = "stat"
      type = "S"
    },
  ]
}

