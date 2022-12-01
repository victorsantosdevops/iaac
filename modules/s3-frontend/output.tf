output "uri_bucket_website" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "arn_bucket_website" {
  value = aws_s3_bucket.website_bucket.arn
}

output "bucket_name" {
  value = aws_s3_bucket.website_bucket.id
}

output "cf_distribuition_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}
output "cf_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}