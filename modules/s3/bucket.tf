data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  aws_region      = data.aws_region.current.name
  account_id      = data.aws_caller_identity.current.account_id

}

resource "aws_s3_bucket" "artifact" {
  # S3 bucket cannot be longer than 63 characters
  bucket = lower(substr("codepipeline-${var.name}-${local.aws_region}-${local.account_id}", 0, 63))

}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.artifact.bucket

  rule {
    id = "log"

    expiration {
      days = 90
    }


    status = "Enabled"

  }

}
resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  bucket = aws_s3_bucket.artifact.id
  acl    = "private"
}


resource "aws_s3_bucket_public_access_block" "artifact" {
  count  = var.s3_block_public_access ? 1 : 0
  bucket = aws_s3_bucket.artifact.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets  = true
}