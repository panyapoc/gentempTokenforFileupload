#!/bin/bash

# API endpoint to generate temporary credentials
API_ENDPOINT="https://ei8zmuxdrl.execute-api.us-east-1.amazonaws.com/Prod/genToken"

# S3 bucket name and file to upload
BUCKET_NAME="gentoken-samplebucket-x4zismgzhfht"
FILE_PATH="samplefile.txt"

# Function to call the API and extract credentials
get_credentials() {
    # Make the API request
    response=$(curl -s -X POST "$API_ENDPOINT")

    # Check if the API request was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to make the API request."
        exit 1
    fi

    # Extract credentials from the response
    access_key_id=$(echo "$response" | jq -r '.AccessKeyId')
    secret_access_key=$(echo "$response" | jq -r '.SecretAccessKey')
    session_token=$(echo "$response" | jq -r '.SessionToken')

    echo $access_key_id
    echo $secret_access_key
    echo $session_token

    # Check if credentials were successfully extracted
    if [ -z "$access_key_id" ] || [ -z "$secret_access_key" ] || [ -z "$session_token" ]; then
        echo "Error: Failed to extract credentials from the API response."
        exit 1
    fi
}

# Function to upload a file to S3
upload_to_s3() {
    # Set AWS credentials
    export AWS_ACCESS_KEY_ID="$access_key_id"
    export AWS_SECRET_ACCESS_KEY="$secret_access_key"
    export AWS_SESSION_TOKEN="$session_token"

    # Upload the file to S3
    aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$(basename "$FILE_PATH")"

    # Check the exit status of the upload command
    if [ $? -ne 0 ]; then
        echo "Error: Failed to upload the file to S3."
        exit 1
    else
        echo "File uploaded successfully to S3 bucket: $BUCKET_NAME"
    fi
}

# Function to clean up resources
cleanup() {
    # Delete the uploaded file from S3
    aws s3 rm "s3://$BUCKET_NAME/$(basename "$FILE_PATH")"

    # Check the exit status of the delete command
    if [ $? -ne 0 ]; then
        echo "Error: Failed to delete the file from S3."
    else
        echo "File deleted successfully from S3 bucket: $BUCKET_NAME"
    fi
}

# Main script
if [ -z "$API_ENDPOINT" ] || [ -z "$BUCKET_NAME" ] || [ -z "$FILE_PATH" ]; then
    echo "Error: Missing required environment variables."
    echo "Please set API_ENDPOINT, BUCKET_NAME, and FILE_PATH."
    exit 1
fi

get_credentials
upload_to_s3
cleanup
