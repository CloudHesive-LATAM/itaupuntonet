
import logging as log
import sys
import boto3


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
                AttributeDefinitions=[
                    {
                        'AttributeName': 'Artist',
                        'AttributeType': 'S',
                    },
                    {
                        'AttributeName': 'SongTitle',
                        'AttributeType': 'S',
                    },
                ],
                KeySchema=[
                    {
                        'AttributeName': 'Artist',
                        'KeyType': 'HASH',
                    },
                    {
                        'AttributeName': 'SongTitle',
                        'KeyType': 'RANGE',
                    },
                ],
                ProvisionedThroughput={
                    'ReadCapacityUnits': 20,
                    'WriteCapacityUnits': 20,
                },
                TableName=self.table,
            )
        else:
            self.create_rds = False
            log.info ("{} DynamoDB already Exists".format(self.table))
            
    
        # S3
        # dynamodb_client = boto3.client('dynamodb', region_name=self.region)

        
        # existing_tables = dynamodb_client.list_tables()['TableNames']
 
        # if self.table not in existing_tables:
        #     self.create_s3 = True
        #     log.info ("DynamoDB Table {} DOESN'T Exists.. Proceed with its creation ".format(self.table))
        # else:
        #     self.create_s3 = False
        #     log.info ("{} DynamoDB already Exists".format(self.table))
        

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