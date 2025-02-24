# Configure the AWS provider with the desired region
provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket for storing uploaded files
resource "aws_s3_bucket" "file_upload_bucket" {
  bucket = "serverless-file-upload-bucket-0612"  # Unique bucket name
}

# Create a DynamoDB table to store file metadata
resource "aws_dynamodb_table" "file_metadata" {
  name         = "file-metadata"
  billing_mode = "PAY_PER_REQUEST"  # On-demand billing mode
  hash_key     = "file_id"          # Primary key attribute

  attribute {
    name = "file_id"
    type = "S"  # String type attribute for file_id
  }
}

# Define an IAM role for the Lambda function to allow execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_file_upload_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"  # Allow Lambda service to assume this role
      }
    }]
  })
}

# Create an API Gateway (HTTP API) for handling file upload requests
resource "aws_apigatewayv2_api" "file_upload_api" {
  name          = "FileUploadAPI"
  protocol_type = "HTTP"

  # Configure CORS to allow requests from the S3 website hosting your client
  cors_configuration {
    allow_origins  = ["https://file-upload-website001.s3.us-east-1.amazonaws.com"] # Allowed origin
    allow_methods  = ["POST", "OPTIONS"]   # Allowed HTTP methods
    allow_headers  = ["Content-Type", "Authorization"]  # Allowed headers
    expose_headers = ["x-amzn-RequestId", "x-amzn-ErrorType"]  # Exposed headers
    max_age        = 300  # Cache CORS preflight request for 300 seconds
  }
}

# Attach the AmazonS3FullAccess policy to the Lambda execution role for S3 access
resource "aws_iam_policy_attachment" "lambda_s3_access" {
  name       = "lambda_s3_access"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Attach the AmazonDynamoDBFullAccess policy to the Lambda execution role for DynamoDB access
resource "aws_iam_policy_attachment" "lambda_dynamodb_access" {
  name       = "lambda_dynamodb_access"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Define the Lambda function that will process file uploads
resource "aws_lambda_function" "file_upload_lambda" {
  filename         = "lambda_function_payload.zip"  # Deployment package file
  function_name    = "file_upload_lambda"
  role             = aws_iam_role.lambda_exec_role.arn  # IAM role for Lambda
  handler          = "lambda_function.lambda_handler"   # Function entry point in the code
  runtime          = "python3.9"  # Runtime environment for Lambda
  source_code_hash = filebase64sha256("lambda_function_payload.zip")  # For code updates

  # Environment variables passed to the Lambda function
  environment {
    variables = {
      S3_BUCKET      = aws_s3_bucket.file_upload_bucket.bucket
      DYNAMODB_TABLE = aws_dynamodb_table.file_metadata.name
    }
  }
}

# Create an API Gateway integration to connect the HTTP API to the Lambda function
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.file_upload_api.id
  integration_type = "AWS_PROXY"  # Use AWS_PROXY integration for Lambda proxy integration
  integration_uri  = aws_lambda_function.file_upload_lambda.invoke_arn
}

# Define a route on the API Gateway for POST requests to the /upload endpoint
resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.file_upload_api.id
  route_key = "POST /upload"  # Route key for file uploads
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Create a default stage for the API with auto-deployment enabled
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.file_upload_api.id
  name        = "$default"  # Default stage name
  auto_deploy = true        # Automatically deploy API changes
}

# Grant API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_upload_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.file_upload_api.execution_arn}/*/*"
}

# Output the API endpoint URL for accessing the file upload service
output "api_url" {
  value = aws_apigatewayv2_api.file_upload_api.api_endpoint
}
