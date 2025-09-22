
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

    policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "PublicReadGetObject"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                resource = "${aws_s3_bucket.sk_nextjs_bucket.arn}/*"
            }
        ]

    })
  
}

# Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {

    comment = "OAI for Next.JS portfolio site."
  
}

# Cloudfront distribution
resource "aws_cloudfront_distribution" "nextjs_distribution" {
    origin {
      domain_name = aws_s3_bucket.sk_nextjs_bucket.bucket_domain_name,
      origin_id = "S3-nextjs-portfolio-bucket"

      s3_origin_config {
        
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
      }
    }
  
    enabled = true
    is_ipv6_enabled = true
    comment = "Next.JS portfolio site"
    default_root_object = "index.html"


    default_cache_behavior {
      
      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods = ["GET", "HEAD"]
      target_origin_id = "S3-nextjs-portfolio-bucket"

      forwarded_values {
        query_string = false
        cookies {
            forward = "none"
        }
      }

      viewer_protocol_policy = "redirect-to-https"
      min_ttl = 0
      default_ttl = 3600
      max_ttl = 86400
    }

     restrictions {
        geo_restriction {
          restriction_type = "none"
        }
      
    }

    viewer_certificate {
        cloudfront_default_certificate = true
      
    }


   
}

