#AWS region

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

#S3 bucket name
variable "bucket_name" {
  description = "The name of the S3 bucket for static website hosting"
  type        = string
}

#Cloud front comment
variable "cloudfront_comment" {
  description = "Comment for the Cloud distribution"
  type        = string
  default     = "Static website using S3 and CloudFront"
}