terraform {
  backend "s3" {
    bucket = "sk-tf-website-state"
    key = "global/s3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "sk-db-lock-table"
    
  }
}