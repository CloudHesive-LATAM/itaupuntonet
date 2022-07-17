#!/bin/bash
account=308582334619
reason="terraform"
project="puntonet"
environment="dev"
dynamodb_table_name="$account-$reason-$project-$environment-dynamo"
bucket_s3="$account-$reason-$project-$environment-bucket"
profile="default"
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts --profile=$profile assume-role --role-arn "arn:aws:iam::308582334619:role/STSFromCICDPipelineAccount" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
python3 checkDynamoAndS3Bucket.py $dynamodb_table_name $bucket_s3