import json
import boto3

bucket_name = "308582334619-terraform-puntonet-dev-bucket"
bucket_policy = {
    "Id": "PreventS3Statefrombeingdeleted",
    "Statement": [
      {
        "Sid": "Bucketprotectionñpolicy",
        "Action": [
          "s3:DeleteBucket",
          "s3:DeleteBucketPolicy"
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

bucket_policy = json.dumps(bucket_policy)

# Set the new policy
s3 = boto3.client('s3')
s3.put_bucket_policy(Bucket=bucket_name, Policy=bucket_policy)

