terraform {
  backend "s3" {
    profile        = "default"
    bucket         = "sandbox-bar-terraform-state"
    region         = "eu-west-1"
    key            = "states/static-web-hosting/terraform.tfstate"
    dynamodb_table = "sandbox-bar-terraform-lock"
  }
}

module "new-static-web-hosting" {
  source = "../modules/S3/"

  bucket_name = "a-web-static-bucket"
}
