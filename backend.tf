terraform {
  backend "s3" {
    bucket = "my-dev-tfstate-s3"
    key = "main"
    region = "eu-west-2"
    dynamodb_table = "terraform-state-lock"
  }
}
