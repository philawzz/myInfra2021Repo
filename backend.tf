terraform {
  backend "s3" {
    bucket = "sigmatek-terraform-state"
    key = "main"
    region = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
  }
}
