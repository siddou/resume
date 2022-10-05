resource "random_pet" "this" {
  length = 2
}
module "s3-bucket" {
  source                  = "terraform-aws-modules/s3-bucket/aws"
  version                 = "~> 3.0"
  bucket                  = "s3-one-${random_pet.this.id}"
  force_destroy           = true
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
  attach_policy           = true
  policy                  = data.aws_iam_policy_document.bucket_policy.json
  versioning = {
    enabled = false
  }
}

# resource "aws_kms_key" "objects" {
#   description = "KMS key is used to encrypt bucket objects"
# }

data "aws_iam_policy_document" "bucket_policy" {
  policy_id = "PolicyForCloudFrontPrivateContent"
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${module.s3-bucket.s3_bucket_arn}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}
