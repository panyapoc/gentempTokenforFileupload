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



# C# Example

https://docs.aws.amazon.com/AmazonS3/latest/userguide/upload-objects.html

To upload a file to Amazon S3 using .NET Framework and AWS SDK, you can follow these steps:

1. **Install AWS SDK for .NET**
   If you haven't already installed the AWS SDK for .NET, you can install it using NuGet Package Manager. In Visual Studio, go to `Tools` > `NuGet Package Manager` > `Manage NuGet Packages for Solution`. Search for `AWSSDK.S3` and install the latest version.

2. **Import Required Namespaces**
   In your C# code file, add the following namespace imports:

   ```csharp
   using Amazon.S3;
   using Amazon.S3.Transfer;
   ```

3. **Configure AWS Credentials**
   You need to provide your AWS credentials (Access Key ID and Secret Access Key) to authenticate with AWS. You can do this in several ways, but for this example, we'll use the `BasicAWSCredentials` class:

   ```csharp
   var accessKeyId = "YOUR_AWS_ACCESS_KEY_ID";
   var secretAccessKey = "YOUR_AWS_SECRET_ACCESS_KEY";
   var credentials = new Amazon.Runtime.BasicAWSCredentials(accessKeyId, secretAccessKey);
   ```

4. **Create an S3 Client**
   Create an instance of the `AmazonS3Client` class using the AWS credentials:

   ```csharp
   var s3Client = new AmazonS3Client(credentials, Amazon.RegionEndpoint.USEast1); // Replace with your desired AWS region
   ```

5. **Upload the File**
   Use the `TransferUtility` class to upload the file to S3:

   ```csharp
   var fileTransferUtility = new TransferUtility(s3Client);
   var filePath = @"C:\path\to\your\file.txt"; // Replace with the actual file path
   var bucketName = "your-bucket-name"; // Replace with your S3 bucket name
   var keyName = "folder/file.txt"; // Replace with the desired key (file path) in S3

   var fileTransferUtilityRequest = new TransferUtilityUploadRequest
   {
       BucketName = bucketName,
       Key = keyName,
       FilePath = filePath
   };

   fileTransferUtility.Upload(fileTransferUtilityRequest);
   ```

   The `TransferUtility` class provides additional options and events for monitoring the upload progress and handling failures.

Here's the complete code snippet:

```csharp
using Amazon.S3;
using Amazon.S3.Transfer;

namespace UploadFileToS3
{
    class Program
    {
        static void Main(string[] args)
        {
            var accessKeyId = "YOUR_AWS_ACCESS_KEY_ID";
            var secretAccessKey = "YOUR_AWS_SECRET_ACCESS_KEY";
            var credentials = new Amazon.Runtime.BasicAWSCredentials(accessKeyId, secretAccessKey);

            var s3Client = new AmazonS3Client(credentials, Amazon.RegionEndpoint.USEast1);

            var fileTransferUtility = new TransferUtility(s3Client);
            var filePath = @"C:\path\to\your\file.txt";
            var bucketName = "your-bucket-name";
            var keyName = "folder/file.txt";

            var fileTransferUtilityRequest = new TransferUtilityUploadRequest
            {
                BucketName = bucketName,
                Key = keyName,
                FilePath = filePath
            };

            fileTransferUtility.Upload(fileTransferUtilityRequest);
        }
    }
}
```

Make sure to replace `YOUR_AWS_ACCESS_KEY_ID`, `YOUR_AWS_SECRET_ACCESS_KEY`, `filePath`, `bucketName`, and `keyName` with your actual values.

Note: It's generally recommended to use more secure methods for storing and managing AWS credentials, such as environment variables, AWS credential files, or AWS Identity and Access Management (IAM) roles, instead of hardcoding them in your code.


Sure, here's a how-to usage for the `json2bash_export.sh` script:

## Usage json2bash_export

The `json2bash_export.sh` script is a Bash script that takes a JSON input containing AWS credentials (Access Key ID, Secret Access Key, and Session Token) and generates Bash export statements that can be used to set the corresponding environment variables.

```
./json2bash_export.sh <json_input>
```

Replace `<json_input>` with the JSON string containing the AWS credentials. The JSON input should have the following format:

```json
{
  "AccessKeyId": "your_access_key_id",
  "SecretAccessKey": "your_secret_access_key",
  "SessionToken": "your_session_token",
  "Expiration": "expiration_time_in_iso_format (optional)"
}
```

## Example

```bash
$ sh json2bash_export.sh '{
    "AccessKeyId": "xxxxxx",
    "Expiration": "2024-05-23 18:56:04+00:00",
    "SecretAccessKey": "xxxxxx",
    "SessionToken": "xxxxxx"
}'
```