import boto3
import os
import json

SECRET_ARN = os.environ.get('SECRET_ARN')

session = boto3.session.Session()
secrets_manager = session.client(service_name='secretsmanager')

# Define a function to retrieve IAM user credentials from AWS Secrets Manager
def get_iam_credentials(secret_name):
    print(f'SECRET_ARN: ${secret_name}')
    get_secret_value_response = secrets_manager.get_secret_value(SecretId=secret_name)

    if 'SecretString' in get_secret_value_response:
        secret = get_secret_value_response['SecretString']
        credentials = json.loads(secret)
    else:
        credentials = json.loads(get_secret_value_response['SecretBinary'].decode('utf-8'))

    return credentials

# Retrieve IAM user credentials from AWS Secrets Manager
iam_credentials = get_iam_credentials(SECRET_ARN)

# Create an STS client using the retrieved credentials
sts = boto3.client(
    'sts',
    aws_access_key_id=iam_credentials['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key=iam_credentials['AWS_SECRET_ACCESS_KEY']
)

# Define the Lambda handler function
def lambda_handler(event, context):
    
    # Grab Token from HTTP POST body
    # request_body = event.get('body')
    # pos_id = body_data.get('POS_ID')

    # You can modify this part to control access base on branch detail
    federated_token = sts.get_federation_token(
        Name='POSID-XXXXXXXXXX',
        Policy=json.dumps({
            'Version': '2012-10-17',
            'Statement': [
                {
                    'Effect': 'Allow',
                    'Action': '*',
                    'Resource': '*'
                }
            ]
        }),
        DurationSeconds=3600
    )['Credentials']

    # Return the generated federated token
    return {
        'statusCode': 200,
        'body': json.dumps(federated_token, indent=4, sort_keys=True, default=str)
    }



