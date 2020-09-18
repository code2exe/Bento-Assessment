terraform {
  backend "s3" {
    bucket = "bento-backend"
    key    = "terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
  }
}