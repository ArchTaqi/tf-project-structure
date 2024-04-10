#####################################
# S3 Bucket Settings
#####################################
module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "4.0.0"
  name    = var.bucket_name

  acl                = var.acl
  enabled            = var.enabled
  user_enabled       = var.user_enabled
  force_destroy      = var.force_destroy
  versioning_enabled = var.versioning_enabled
  sse_algorithm      = var.sse_algorithm

  block_public_acls             = var.block_public_acls
  allow_encrypted_uploads_only  = var.allow_encrypted_uploads_only
  allow_ssl_requests_only       = var.allow_ssl_requests_only
  block_public_policy           = var.block_public_policy
  ignore_public_acls            = var.ignore_public_acls
  cors_configuration            = var.allowed_bucket_cors
  allowed_bucket_actions        = var.allowed_bucket_actions
  lifecycle_configuration_rules = var.lifecycle_configuration_rules

  logging = var.access_log_bucket_name == "" ? null : [
    {
      bucket_name = var.access_log_bucket_name
      prefix      = "${var.access_log_bucket_prefix}-${var.bucket_name}/"
    }
  ]

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Terraform   = "Yes"
  }
}
