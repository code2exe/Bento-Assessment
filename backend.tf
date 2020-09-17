# terraform {
    backend "s3" {
        bucket = "bytelabs"
        key = "terraform.tfstate" 
        region = "eu-west-2"
        encrypt = true
    }
# }