# Sample genToken API

This Python code is an AWS Lambda function that retrieves temporary AWS credentials (federated token) from AWS Security Token Service (STS) using IAM user credentials stored in AWS Secrets Manager.

# How it works

The genToken API generates temporary AWS credentials using AWS Security Token Service (STS). Here's how it works:

1. The client makes a POST request to the API Gateway endpoint.
2. API Gateway triggers the associated Lambda function (`genToken/app.py`).
3. The Lambda function retrieves AWS credentials from AWS Secrets Manager using the provided secret ARN.
4. The Lambda function uses the retrieved credentials to assume an IAM role and obtain temporary credentials using AWS STS.
5. The temporary credentials, including the access key ID, secret access key, and session token, are returned to the client as a JSON response.
6. The client can then use these temporary credentials to access AWS resources, such as uploading files to an S3 bucket.

# How to Deploy

To deploy the genToken API, follow these steps:

1. Make sure you have the AWS SAM CLI installed and configured with your AWS account.
2. Update the `template.yaml` file with your desired configuration, such as the Lambda function name, IAM role, and API Gateway settings.
3. Run the following command to build and package the Lambda function:
   ```
   sam build
   ```
4. Deploy the stack using the AWS SAM CLI:
   ```
   sam deploy --guided
   ```
   Follow the prompts to provide the necessary information, such as the stack name and AWS region.
5. Once the deployment is complete, you will receive the API Gateway endpoint URL.

# Sample Test Script

The `testscript.sh` script demonstrates how to use the genToken API to retrieve temporary credentials and upload a file to an S3 bucket. Here's how to run the test script:

1. Set the following environment variables:
   - `API_ENDPOINT`: The API Gateway endpoint URL for the genToken API.
   - `BUCKET_NAME`: The name of the S3 bucket to upload the file to.
   - `FILE_PATH`: The path to the file you want to upload.
2. Make sure you have the AWS CLI installed and configured with your AWS account.
3. Run the test script:
   ```
   ./testscript.sh
   ```
   The script will make a request to the genToken API, retrieve the temporary credentials, and use them to upload the specified file to the S3 bucket.
4. Check the output for any error messages or success messages indicating the file upload status.

Note: Make sure to replace the placeholder values in the environment variables with your actual API endpoint, S3 bucket name, and file path.
