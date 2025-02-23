# 30-PROJECT-CHALLENGE
 1. Weather Dashboard - AWS S3 Integration

Project Overview:
The Weather Dashboard is a Python-based project that fetches real-time weather data from the OpenWeather API and stores it in an AWS S3 bucket for long-term storage and analysis. This project automates weather data collection, ensuring secure and structured storage using cloud services.

How It Works:
Fetches weather data for predefined cities (e.g., Philadelphia, Seattle, New York) using the OpenWeather API.
Processes and extracts key weather details, including temperature, humidity, and conditions.
Stores the data in an AWS S3 bucket as JSON files, with a timestamped filename for easy retrieval.
Handles errors gracefully, ensuring robust API requests and AWS interactions.

Key Technologies Used:
Python (Core logic)
AWS S3 (boto3 SDK) for cloud storage
OpenWeather API for real-time weather data
Requests for HTTP API communication
dotenv for secure API key management

Use Case:
This project is ideal for data logging, weather analytics, and cloud storage automation, providing an efficient way to collect and store real-time weather data.



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

 3.NFL Schedule API
 
Project Overview
This project automates the retrieval and presentation of NFL schedules using a Flask-based API. It fetches real-time game schedules from SerpAPI, processes the data, and serves it via a RESTful endpoint. The API is containerized using Docker, making deployment seamless across different environments.

How It Works:
Fetches NFL schedule data from SerpAPI.
Extracts teams, venue, date, and time from the response.
Formats the data into a structured JSON format.
Serves the schedule via a Flask API at the /sports endpoint.
Runs as a Docker container for easy deployment.

Key Technologies:
Flask → Provides a lightweight API framework.
Requests → Handles API calls to SerpAPI.
Python 3.9 → Core programming language.
Docker → Enables containerized deployment.
JSON → Standard format for structuring API responses.

Use Case:
This project is ideal for sports analysts, developers, and NFL enthusiasts looking for a real-time, API-based solution to access NFL schedules. It can be used for:
Integrating NFL schedules into websites or mobile applications.
Automating data retrieval for sports analytics.
Enhancing fantasy football platforms with up-to-date game schedules.

4. Serverless File Upload System - AWS Lambda, API Gateway, S3, and DynamoDB

Project Overview:

The Serverless File Upload System is a cloud-based solution that enables secure and scalable file uploads via a simple web interface. Leveraging AWS serverless services, the project efficiently processes file uploads, stores files in an S3 bucket, and records metadata in a DynamoDB table. This architecture ensures a cost-effective and highly scalable file management system.

How It Works:

Users select and upload files through an intuitive HTML/CSS/JavaScript front-end.
An API Gateway handles HTTP requests and routes them to an AWS Lambda function.
The Lambda function processes the file upload, saving the file in an S3 bucket and recording its metadata (including a unique file identifier and timestamp) in a DynamoDB table.
CORS is configured to allow secure interactions between the web client and AWS services.

Key Technologies Used:

Terraform: Provisioning of AWS resources
AWS Lambda (Python): File processing and serverless execution
API Gateway: HTTP request management and integration with Lambda
AWS S3: Secure file storage
DynamoDB: Metadata storage
HTML, CSS, JavaScript: Front-end interface for file uploads

Use Case:

This project is ideal for applications that require a secure and scalable file storage solution, such as document management systems, media repositories, and other cloud-based file handling applications.