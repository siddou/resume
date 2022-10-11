resource "github_actions_secret" "GH_AWS_ACCESS_KEY_ID" {
  repository      = "resume"
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = aws_iam_access_key.GH_SA.id
}
resource "github_actions_secret" "GH_AWS_SECRET_ACCESS_KEY" {
  repository      = "resume"
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = aws_iam_access_key.GH_SA.secret
}
resource "github_actions_secret" "GH_AWS_BUCKET" {
  repository      = "resume"
  secret_name     = "AWS_BUCKET"
  plaintext_value = module.s3-bucket.s3_bucket_id
}
resource "github_actions_secret" "GH_AWS_REGION" {
  repository      = "resume"
  secret_name     = "AWS_REGION"
  plaintext_value = var.AWS_REGION
}
resource "github_actions_secret" "GH_AWS_DISTRIBUTION_ID" {
  repository      = "resume"
  secret_name     = "AWS_DISTRIBUTION_ID"
  plaintext_value = module.cloudfront.cloudfront_distribution_id
}
resource "github_actions_secret" "GH_INFRACOST_API_KEY" {
  repository      = "resume"
  secret_name     = "INFRACOST_API_KEY"
  plaintext_value = var.INFRACOST_API_KEY
}
resource "aws_iam_user" "GH_SA" {
  name = "GH_SA"
}
resource "aws_iam_access_key" "GH_SA" {
  user = aws_iam_user.GH_SA.name
}
data "aws_caller_identity" "current" {}
resource "aws_iam_policy" "GH_SA" {
  name        = "GH_SA_policy"
  description = "GH_SA policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:ListBucket",
        ]
        Resource = [
          module.s3-bucket.s3_bucket_arn,
          "${module.s3-bucket.s3_bucket_arn}/*",
        ],
      },
      {
        Effect = "Allow"
        Action = ["cloudfront:CreateInvalidation", ]
        Resource = [
          "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${module.cloudfront.cloudfront_distribution_id}",
        ],
      },
    ]
  })
}
resource "aws_iam_user_policy_attachment" "GH_SA" {
  user       = aws_iam_user.GH_SA.name
  policy_arn = aws_iam_policy.GH_SA.arn
}
