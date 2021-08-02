resource "aws_cloudfront_origin_access_identity" "a-web-static-bucket" {
  comment = "Origin Access Identity for a-web-static-bucket"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = module.new-static-web-hosting.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.a-web-static-bucket.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  aliases = ["static-web-hosting.sandbox-bar.gneis.io"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

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

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "sandbox"
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.sandbox.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019" 
  }
}

