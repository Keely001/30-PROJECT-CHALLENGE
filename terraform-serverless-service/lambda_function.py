import boto3
import os
import json
import uuid
from datetime import datetime

# Initialize the S3 client and DynamoDB resource using boto3
s3 = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    try:
        # Handle CORS preflight (OPTIONS) requests
        if event['httpMethod'] == 'OPTIONS':
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Origin': 'https://file-upload-website001.s3.us-east-1.amazonaws.com',
                    'Access-Control-Allow-Methods': 'POST, OPTIONS',
                    'Access-Control-Allow-Headers': 'Content-Type, Authorization'
                }
            }

        # Retrieve S3 bucket and DynamoDB table names from environment variables
        bucket_name = os.environ['S3_BUCKET']
        table_name = os.environ['DYNAMODB_TABLE']
        # Get the DynamoDB table object to perform operations on it
        table = dynamodb.Table(table_name)

        # Parse the incoming request body to extract the file name and content
        body = json.loads(event['body'])
        file_name = body['file_name']
        file_content = body['file_content']  # Expected to be a base64 encoded string

        # Generate a unique file ID and capture the current upload timestamp
        file_id = str(uuid.uuid4())
        upload_time = datetime.now().isoformat()

        # Construct a file path to store the file in S3 (e.g., in an "uploads" folder)
        file_path = f"uploads/{file_id}_{file_name}"
        
        # Upload the file to the specified S3 bucket
        s3.put_object(
            Bucket=bucket_name,
            Key=file_path,
            Body=bytes(file_content, 'utf-8')  # Convert the file content string to bytes
        )

        # Insert file metadata into the DynamoDB table
        table.put_item(
            Item={
                'file_id': file_id,
                'file_name': file_name,
                'file_path': file_path,
                'upload_time': upload_time
            }
        )

        # Return a successful response with CORS headers and the file ID
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': 'https://serverless-file-upload-bucket-0612.s3.us-east-1.amazonaws.com',
                'Access-Control-Allow-Methods': 'POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type, Authorization'
            },
            'body': json.dumps({'message': 'File uploaded successfully', 'file_id': file_id})
        }

    except Exception as e:
        # Handle any exceptions that occur during processing and return an error response
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': 'https://file-upload-website001.s3.us-east-1.amazonaws.com'
            },
            'body': json.dumps({'error': str(e)})
        }
