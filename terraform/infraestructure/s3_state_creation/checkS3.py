import logging as log
import sys
import boto3

class Check:
    region = None
    client = None
    create_bucket = None

    def __init__(self, region, bucket):
        
        self.region = region
        self.table = table
        self.bucket = bucket

    def checkS3Bucket (self, region, bucket):
        s3_client = boto3.client('s3', region_name=self.region)        
        if bucket.creation_date:
            log.info ("S3 Bucket {} already exists ".format(self.bucket))
        else:
            log.info ("S3 Bucket {} will be created ".format(self.bucket))
            s3_client.create_bucket(Bucket=self.bucket)


log.basicConfig(level=log.INFO)

bucketS3 = sys.argv[1]

log.info(f'Bucket S3: {bucketS3}.')
log.info(f'=== Received arguments ===')

checkS3Bucket(region="us-east-1", bucket=bucketS3)