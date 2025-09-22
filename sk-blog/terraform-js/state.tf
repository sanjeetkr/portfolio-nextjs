terraform {
  backend "s3" {
    bucket = "sk-next-my-terraform-state"
    key = "global/s3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "sk-terraform-lock-file-nextjs"
    
  }
}