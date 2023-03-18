terraform {
  backend "s3" {
    bucket = "sigmatek-terraform-state"
    key = "main"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}
