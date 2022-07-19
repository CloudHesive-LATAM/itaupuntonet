#!/bin/bash

# FIRST STEPS, CHECK S3 and DYNAMO
rootPath=$(pwd)

account=308582334619
reason="terraform"
project="puntonet"
environment="dev"
dynamodb_table_name="$account-$reason-$project-$environment-dynamo"
bucket_s3="$account-$reason-$project-$environment-bucket"
profile="itauchile-manpower-pipe"
key="$project-$environment-tfstate"

#profile="default"
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts --profile=$profile assume-role --role-arn "arn:aws:iam::308582334619:role/STSFromCICDPipelineAccount" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))

python3 terraform/infraestructure/s3_state_creation/checkDynamoAndS3Bucket.py $dynamodb_table_name $bucket_s3

# AFTER, START TERRAFORM
cd terraform
cd infraestructure
cd application
# terraform init -backend-config="bucket=$bucket_s3" -backend-config="key=$key" -backend-config="region=us-east-1" -backend-config="dynamodb_table=$dynamodb_table_name" -backend-config="encrypt=true"

# terraform plan

# terraform apply --auto-approve
# sleep 2

# #rm -rf .terraform*

cd $rootPath

cp terraform/modules/02-eks/scripts/kubeconfig-test terraform/configurator/kubeconfig/