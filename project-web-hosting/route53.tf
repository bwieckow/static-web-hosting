data "aws_acm_certificate" "sandbox" {
  domain = "*.sandbox-bar.gneis.io"
  statuses = ["ISSUED"]
  provider = aws.virginia
}

data "aws_route53_zone" "sandbox" {
  name         = "sandbox-bar.gneis.io."
  private_zone = false
}

resource "aws_route53_record" "static_web_hosting" {
  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "static-web-hosting.sandbox-bar.gneis.io"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
