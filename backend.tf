terraform {
  backend "s3" {
    bucket = "mytestapibucket"
    key = "main"
    region = "us-east-1"
    dynamodb_table = "Teraform-lock"
  }
}
