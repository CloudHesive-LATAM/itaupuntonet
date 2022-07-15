# #!/bin/bash
# bucket_name=$1
# dynamodb_table_name=$2
# echo " -------------------- "
# echo " Definited PARAMETERS "
# echo "BucketName: $bucket_name"
# echo "DynamoDBTable: $dynamodb_table_name"
# echo " -------------------- "

# if aws s3api head-bucket --bucket $bucket_name; then
#     echo "Bucket does already exists"
#     exit
# else 
#     cd terraform/infraestructure/s3_state_creation; 
#     terraform init; 
#     terraform plan -var "bucket_state_name=$bucket_name" -var "dynamodb_table_name=$dynamodb_table_name" -out=plan.out; 
#     terraform apply plan.out
# fi

# #!/bin/bash
# account=308582334619
# reason="terraform"
# project="puntonet"
# environment="dev"
# dynamodb_table_name="$account-$reason-$project-$environment-dynamo"
# bucket_s3="$account-$reason-$project-$environment-bucket"
# profile="default"
# export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts --profile=$profile assume-role --role-arn "arn:aws:iam::308582334619:role/STSFromCICDPipelineAccount" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
# python3 checkDynamoAndS3Bucket.py $dynamodb_table_name $bucket_s3

account=308582334619
reason="terraform"
project="puntonet"
environment="dev"
bucket_s3="$account-$reason-$project-$environment-bucket"
profile="default"
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts --profile=$profile assume-role --role-arn "arn:aws:iam::308582334619:role/STSFromCICDPipelineAccount" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
python3 checkS3.py $bucket_s3