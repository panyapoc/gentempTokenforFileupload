#!/bin/bash

# Check if the JSON input is provided
if [ -z "$1" ]; then
    echo "Error: No JSON input provided."
    exit 1
fi

# Parse the JSON input
access_key_id=$(echo "$1" | jq -r '.AccessKeyId')
secret_access_key=$(echo "$1" | jq -r '.SecretAccessKey')
session_token=$(echo "$1" | jq -r '.SessionToken')
expiration=$(echo "$1" | jq -r '.Expiration')

# Check if the required fields are present
if [ -z "$access_key_id" ] || [ -z "$secret_access_key" ] || [ -z "$session_token" ]; then
    echo "Error: Missing required fields in the JSON input."
    exit 1
fi

# Print the export statements
echo "======================= COPY THE FOLLOWING ======================="
echo "export AWS_ACCESS_KEY_ID=$access_key_id"
echo "export AWS_SECRET_ACCESS_KEY=$secret_access_key"
echo "export AWS_SESSION_TOKEN=$session_token"