resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = ""
  }
}
