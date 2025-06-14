output "website_url" {
  value       = s3-bucket-website-aaronbuma.website.website_endpoint
  description = "The public URL of the static website"
}

output "bucket_name" {
  value       = s3-bucket-website-aaronbuma.website.bucket
  description = "The name of the S3 bucket"
}