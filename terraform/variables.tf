variable "bucket_name" {
  description = "The name of the S3 bucket for static website"
  type        = string
  default     = "s3-bucket-website-aaronbuma"
}

variable "aws_credentials_path" {
  description = ".aws/credentials"
  default     = "~/.aws/credentials"
}

$ terraform init