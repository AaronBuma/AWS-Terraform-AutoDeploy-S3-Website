provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "static_site_bucket" {
  bucket        = "s3-bucket-website-aaronbuma"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "Static Website"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = true
  block_public_policy     = false  # allow public access via bucket policy
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_site_bucket.arn}/*"
      }
    ]
  })
}

output "bucket_name" {
  value       = aws_s3_bucket.static_site_bucket.bucket
  description = "The name of the S3 bucket"
}

output "website_url" {
  value       = aws_s3_bucket.static_site_bucket.website_endpoint
  description = "The public URL of the static website"
}
