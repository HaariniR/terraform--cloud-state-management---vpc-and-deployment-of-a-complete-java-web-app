terraform {
  backend "s3" {
    bucket = "terraform-bucket100"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}