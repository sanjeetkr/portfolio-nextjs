
provider "aws" {
  region = "us-east-1"    
}

# S3 bucket
resource "aws_s3_bucket" "sk_nextjs_bucket" {
    bucket = "sk-nextjs-portfolio-bucket"
}

# Ownership Control
resource "aws_s3_bucket_ownership_controls" "sk_nextjs_bucket_owenrship_controls" {
    bucket = aws_s3_bucket.sk_nextjs_bucket.id

    rule {
      object_ownership = "BucketOwnerPreferred"
    }
  
}

# Disabling Block public access
resource "aws_s3_bucket_public_access_block" "sk_nextjs_bucket_public_access_block" {
    bucket = aws_s3_bucket.sk_nextjs_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
  
}

# Bucket ACL
resource "aws_s3_bucket_acl" "sk_nextjs_bucket_acl" {

    depends_on = [ 
        aws_s3_bucket_ownership_controls.sk_nextjs_bucket_owenrship_controls,
        aws_s3_bucket_public_access_block.sk_nextjs_bucket_public_access_block 
        ]

    bucket = aws_s3_bucket.sk_nextjs_bucket.id
    acl = "public-read"
  
}

# Bucket Policy
resource "aws_s3_bucket_policy" "sk_nextjs_bucket_policy" {
    bucket = aws_s3_bucket.sk_nextjs_bucket.id

    policy = jsonencode(({
        version = "2012-10-17"
        Statement = [
            {
                Sid = "PublicReadGetObject"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                resource = "${aws_s3_bucket.sk_nextjs_bucket.arn}/*"
            }
        ]

    }))
  
}

