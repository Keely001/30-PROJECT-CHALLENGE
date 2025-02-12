# 30-PROJECT-CHALLENGE

Weather Dashboard - AWS S3 Integration
Project Overview
The Weather Dashboard is a Python-based project that fetches real-time weather data from the OpenWeather API and stores it in an AWS S3 bucket for long-term storage and analysis. This project automates weather data collection, ensuring secure and structured storage using cloud services.

How It Works
Fetches weather data for predefined cities (e.g., Philadelphia, Seattle, New York) using the OpenWeather API.
Processes and extracts key weather details, including temperature, humidity, and conditions.
Stores the data in an AWS S3 bucket as JSON files, with a timestamped filename for easy retrieval.
Handles errors gracefully, ensuring robust API requests and AWS interactions.
Key Technologies Used
Python (Core logic)
AWS S3 (boto3 SDK) for cloud storage
OpenWeather API for real-time weather data
Requests for HTTP API communication
dotenv for secure API key management
Use Case
This project is ideal for data logging, weather analytics, and cloud storage automation, providing an efficient way to collect and store real-time weather data.
