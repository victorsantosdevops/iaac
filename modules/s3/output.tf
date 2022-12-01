output "uri_bucket_pipelines" {
  value = aws_s3_bucket.artifact.bucket
}

output "arn_bucket_pipelines" {
  value = aws_s3_bucket.artifact.arn
}