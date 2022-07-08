#!/bin/bash
bucket_name=$1
dynamodb_table_name=$2
echo " -------------------- "
echo " Definited PARAMETERS "
echo "BucketName: $bucket_name"
echo "DynamoDBTable: $dynamodb_table_name"
echo " -------------------- "

if aws s3api head-bucket --bucket $bucket_name; then
    echo "Bucket does already exists"
    exit
else 
    cd terraform/infraestructure/s3_state_creation; 
    terraform init; 
    terraform plan -var "bucket_state_name=$bucket_name" -var "dynamodb_table_name=$dynamodb_table_name" -out=plan.out; 
    terraform apply plan.out
fi
