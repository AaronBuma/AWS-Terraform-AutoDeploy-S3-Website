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
    Environment = "Prod"
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

resource "aws_s3_bucket_policy" "allow_cloudfront_only" {
  bucket = aws_s3_bucket.static_site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowCloudFrontAccessOnly",
        Effect: "Allow",
        Principal: {
          Service: "cloudfront.amazonaws.com"
        },
        Action: "s3:GetObject",
        Resource: "${aws_s3_bucket.static_site_bucket.arn}/*",
        Condition: {
          StringEquals: {
            "AWS:SourceArn": "arn:aws:cloudfront::205998077843:distribution/E52G9QERKV43T"
          }
        }
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
  description = "This will 403; use CloudFront URL instead"
}
