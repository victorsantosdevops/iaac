resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_domain_name
    origin_id   = "website"
  }

  logging_config {
    bucket          = aws_s3_bucket.website_bucket.bucket_domain_name
    include_cookies = true
    prefix          = "logs"
  }

  enabled             = true
  default_root_object = "index.html"
  aliases = [var.domain_aliase]
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "website"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "${aws_s3_bucket.website_bucket.bucket_domain_name}-distribution-${var.environment}"
    Environment = var.environment
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cnd_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}