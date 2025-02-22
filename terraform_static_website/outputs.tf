output "cloudfront_url" {
  value       = aws_cloudfront_distribution.website_cdn.domain_name
  description = "The CloudFront URL of your website"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.website_bucket.bucket
  description = "The name of the S3 bucket used for website hosting"
}

