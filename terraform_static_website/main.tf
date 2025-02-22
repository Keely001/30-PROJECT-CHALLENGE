#Define AWS as the provider

provider "aws" {
  region = var.aws_region #Retrieve the AWS region from the variables file.
}

#Create an S3 bucket for the static website
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name #Retrieve bucket name from the variables file.acceleration_status

  tags = {
    Name        = "Website bucket"
    Environment = "devpt-dept"
  }

}

#Upload index.html to S3
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website_bucket.bucket # Reference the S3 bucket
  key          = "index.html"                        # Object key in S3
  source       = "./website-files/index.html"        # Local file path
  content_type = "text/html"                         # Ensure correct MIME type
}

# Upload error.html to S3
resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "error.html"
  source       = "./website-files/error.html"
  content_type = "text/html"
}


#Configure the resource
resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.website_bucket.id #retrieve bucket id

  #setting the file locations
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontAccess"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website_cdn.arn
          }
        }
      }
    ]
  })

}

#AWS Cloudfront CDN

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "WebsiteOAC"
  description                       = "Access control for Cloudfront to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#AWS cloudfront distribution setup

resource "aws_cloudfront_distribution" "website_cdn" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = "S3WebsiteOrigin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3WebsiteOrigin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

  }

}

#AWS CloudFront - Caching Policy (Using Built-in Policy)

data "aws_cloudfront_cache_policy" "caching_policy" {
  name = "Managed-CachingOptimized"
}

resource "aws_iam_policy" "name" {
  name        = "TerraformS3CloudFrontPolicy"
  description = "IAM policy for terraform to manage S3 and CloudFront"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "cloudfront:*"
        ],
        Resource = "*"
      }
    ]
  })
}