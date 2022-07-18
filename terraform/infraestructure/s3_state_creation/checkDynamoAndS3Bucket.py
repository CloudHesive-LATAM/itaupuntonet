
import logging as log
import sys
import boto3
import json
import botocore.exceptions


# [STEP 1] - Define CLASS Object Manager
class Checker:
    region = None
    client = None
    create_bucket = None
    create_rds = None

    def __init__(self, region, table, bucket):
        
        self.region = region
        self.table = table
        self.bucket = bucket

    def checkTerraformResources (self, region, table, bucket):
        dynamodb_client = boto3.client('dynamodb', region_name=self.region)

        
        existing_tables = dynamodb_client.list_tables()['TableNames']
 
        if self.table not in existing_tables:
            self.create_rds = True
            log.info ("DynamoDB Table {} DOESN'T Exists.. Proceed with its creation ".format(self.table))
            response = dynamodb_client.create_table(
                
                KeySchema=[
                    {
                    'AttributeName': 'LockID',
                    'KeyType': 'HASH',
                    }
                ],
                AttributeDefinitions=[
                    {
                    'AttributeName': 'LockID',
                    'AttributeType': 'S',
                    }
                ],
                BillingMode= 'PAY_PER_REQUEST',
                TableName=self.table,
            )
        
        else:
            self.create_rds = False
            log.info ("{} DynamoDB already exists".format(self.table))

        ## Checks if Bucket is created and if it is not it will be created and configured.

        s3 = boto3.resource('s3')
        bucket_name = self.bucket    
        bucket = s3.Bucket(self.bucket)

        if bucket.creation_date:
            log.info ("{} Bucket exists".format(self.bucket))        
        else:
            log.info ("{} Bucket will be created and configured".format(self.bucket))
            
            # Creates Bucket
            
            bucket.create(Bucket=self.bucket)
            
            # Creates Bucket Policy
                
            bucket_policy = {
                    "Id": "PreventS3Statefrombeingdeleted",
                    "Statement": [
                        {
                            "Sid": "Bucketprotectionpolicy",
                            "Action": [
                                "s3:DeleteBucket"
                            ],
                            "Effect": "Deny",
                            "Resource": f"arn:aws:s3:::{bucket_name}",
                            "Principal": {
                                "AWS": [
                                    "*"
                                    ]
                                }
                            }
                        ]
                    }

            # Converts policy from json to string
            
            bucket_policy = json.dumps(bucket_policy)

            # Sets the new policy in the Bucket
            
            s3_client = boto3.client('s3')
            s3_client.put_bucket_policy(Bucket=bucket_name, Policy=bucket_policy)

            # Provides information about wether the policy was linked with the Bucket
            
            s3policylinked=s3_client.get_bucket_policy(Bucket=bucket_name)
            s3policylinkedparsed=s3policylinked["Policy"]
            log.info ("Policy Document of Bucket {} is as follows:".format(self.bucket))
            log.info(s3policylinkedparsed)

            # S3 Bucket versioning

            log.info ("{} Bucket will have versioning enabled".format(self.bucket))
            
            # Enables Bucket Versioning
            
            versioning = s3_client.put_bucket_versioning(Bucket=bucket_name, VersioningConfiguration=
                {
            'MFADelete': 'Disabled',
            'Status': 'Enabled'
                }
            )
            
            # Provides information about Status of Versioning
            
            versioning_response = s3_client.get_bucket_versioning(Bucket=bucket_name)
            parsed_versioning_response = versioning_response["Status"]
            log.info("Status of versioning in Bucket {} is as follows: ".format(self.bucket))
            log.info(parsed_versioning_response)

            # Blocks Bucket public access
            
            block_public_access = s3_client.put_public_access_block(Bucket=bucket_name, PublicAccessBlockConfiguration=
                {
            'BlockPublicAcls': True,
            'IgnorePublicAcls': True,
            'BlockPublicPolicy': True,
            'RestrictPublicBuckets': True
                }
            )

            # Provides information about status of public access of Bucket
            
            block_publicaccess_response = s3_client.get_public_access_block(Bucket=bucket_name)
            parsed_block_publicaccess_response = block_publicaccess_response["PublicAccessBlockConfiguration"]
            log.info ("Configuration of Public access block for Bucket {} is as follows: ".format(self.bucket))
            log.info (parsed_block_publicaccess_response)

            # Apply Server Side Encryption
             
            serverside_encryption = s3_client.put_bucket_encryption(
                Bucket=bucket_name,
                ServerSideEncryptionConfiguration={
                    'Rules': [
                        {
                            'ApplyServerSideEncryptionByDefault': {
                            'SSEAlgorithm': 'AES256'
                            }
                        },
                    ]
                }
            )

            s3sse_configuration = s3_client.get_bucket_encryption(Bucket=bucket_name)
            s3sse_configuration_parsed =  s3sse_configuration["ServerSideEncryptionConfiguration"]
            log.info("Configuration of encryption in Bucket {} is as follows: ".format(self.bucket))
            log.info(s3sse_configuration_parsed)



#EOF------------------------------------------------------------------------------------------------------------

# [STEP 1] - Instantiate and configure object manager
log.basicConfig(level=log.INFO)

# Parse received arguments
dynamoTable = sys.argv[1]
bucketS3 = sys.argv[2]

log.info(f'=== Received arguments ===')
log.info(f'DynamoTable: {dynamoTable}.')
log.info(f'Bucket S3: {bucketS3}.')
log.info(f'=== Received arguments ===')

chk = Checker("us-east-1", dynamoTable, bucketS3)
chk.checkTerraformResources("us-east-1", dynamoTable, bucketS3)