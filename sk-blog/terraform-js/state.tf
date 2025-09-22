terraform {
  backend "s3" {
    bucket = "sk-my-tf-website-state"
    key = "global/s3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "sk-my-db-lock-website-table"
    
  }
}