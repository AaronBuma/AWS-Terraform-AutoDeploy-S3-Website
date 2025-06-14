provider "aws" {
  region = "us-east-2"  # change to your preferred region
}

resource "aws_s3_bucket" "website" {
  bucket = "s3-bucket-website-aaronbuma"

  # Enable static website hosting
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  # Block all public access (we'll use bucket policy for public read)
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = ["s3:GetObject"],
      Resource  = "${aws_s3_bucket.website.arn}/*"
    }]
  })
}

output "bucket_name" {
  value       = aws_s3_bucket.website.bucket
  description = "The name of the S3 bucket"
}

output "website_url" {
  value       = aws_s3_bucket.website.website_endpoint
  description = "The public URL of the static website"
}
