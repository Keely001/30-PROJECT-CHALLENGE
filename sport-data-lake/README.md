2. NBA Sports Analytics Data Lake

Project Overview:
This project automates the collection, storage, and analysis of NBA player data using AWS services. It fetches real-time player statistics from SportsData.io and stores them in an AWS S3 data lake, making the data available for further processing using AWS Glue and Amazon Athena.

How It Works:
Fetches NBA player data from the SportsData.io API.
Creates an AWS S3 bucket to store raw NBA data in line-delimited JSON format.
Creates an AWS Glue database and table to catalog the stored data.
Uploads the NBA data to the S3 bucket for further processing.
Configures AWS Athena to enable SQL queries on the collected data.

AWS Services Used:
Amazon S3 → Stores raw NBA player data.
AWS Glue → Creates a metadata catalog for querying data in S3.
Amazon Athena → Runs SQL queries on structured NBA data.
AWS Lambda (Future Enhancement) → Can be used for automated data ingestion.

Key Technologies:
Python (Data fetching & AWS automation)
Boto3 (AWS SDK for Python)
Requests (API communication with SportsData.io)
JSON (Structured storage format)
AWS Glue & Athena (Data lake & querying)

Use Case:
This project is ideal for sports analysts, data scientists, and NBA enthusiasts looking to analyze player performance using a serverless, cloud-native solution. 