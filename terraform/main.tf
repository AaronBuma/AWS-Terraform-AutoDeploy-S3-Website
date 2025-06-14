provider "aws" {
  region = "us-east-2"  
}

resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "s3-bucket-website-aaronbuma"
  force_destroy = true
  terraform destroy
  
  # Enable static website hosting
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
 
resource "aws_s3_bucket_ownership_controls" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_site_bucket" {
  depends_on = [
	aws_s3_bucket_public_access_block.static_site_bucket,
	aws_s3_bucket_ownership_controls.static_site_bucket,
  ]

  bucket = aws_s3_bucket.static_site_bucket.id
  acl    = "public-read"
}
 
output "bucket_name" {
  value       = aws_s3_bucket.static_site_bucket.bucket
  description = "The name of the S3 bucket"
}

output "website_url" {
  value       = aws_s3_bucket.static_site_bucket.website_endpoint
  description = "The public URL of the static website"
}
