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
region="us-east-1"

# [STEP 1] - Connect to CICD jenkins account (remove profile when code is moved to Jenkins) 

# [STEP 2] - do STS To DevAccount 
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts --profile=$profile assume-role --role-arn "arn:aws:iam::308582334619:role/STSFromCICDPipelineAccount" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
#echo $(aws sts get-caller-identity)

# [STEP 3] - get cluster Kubeconfig and add to context 
clusterName=$(aws eks list-clusters --region $region | jq .clusters[0] | tr -d '"')
aws eks update-kubeconfig --name $clusterName --region $region

# [STEP 4] - Now, its time to play
# non_root_role="non-root-eks-role-dev"

# unset AWS_ACCESS_KEY_ID
# unset AWS_SECRET_ACCESS_KEY
# unset AWS_SESSION_TOKEN

# export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts --profile=$profile assume-role --role-arn "arn:aws:iam::308582334619:role/non-root-eks-role-dev" --role-session-name NonRootEKS --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
# echo $(aws sts get-caller-identity)
# clusterName=$(aws eks list-clusters --region $region | jq .clusters[0] | tr -d '"')
# aws eks update-kubeconfig --name $clusterName --region $region
#kubectl get -n kube-system configmap/aws-auth -o yaml


# # [STEP 5] - Patch K8s auth CMap

ROLE="    - rolearn: arn:aws:iam::${account}:role/non-root-eks-role-dev\n      username: deployer-eks\n      groups:\n        - system:masters"

kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > /tmp/aws-auth-patch.yml
cat /tmp/aws-auth-patch.yml
kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"


kubectl get -n kube-system configmap/aws-auth -o yaml

sleep 5
kubectl auth can-i get pods --as deployer-eks
# # [STEP 6] - Once patched, STS to the role and check if everything is ok

# # [STEP 6] - Once done, build additional Role and RoleBindings (or ClusterRole + ClusterRoleBinding)
# kubectl apply -f terraform/configurator/scripts/deployer-limited-rbac.yml || echo "role Deployer already created"
# kubectl apply -f terraform/configurator/scripts/reader-limited-rbac.yml || echo "role reader already created"

# kubectl apply -f cm.yaml 

#cat cm.yaml

# - rolearn: arn:aws:iam::308582334619:role/non-root-eks-role-dev
#       username: system:node:{{EC2PrivateDNSName}}
#       groups:
#         - role-deployer

# [STEP 3] - Based on NonRool ROLE, create NON Root EKS cluster

# python3 terraform/infraestructure/s3_state_creation/checkDynamoAndS3Bucket.py $dynamodb_table_name $bucket_s3

# # AFTER, START TERRAFORM
# cd terraform
# cd infraestructure
# cd application
# # terraform init -backend-config="bucket=$bucket_s3" -backend-config="key=$key" -backend-config="region=us-east-1" -backend-config="dynamodb_table=$dynamodb_table_name" -backend-config="encrypt=true"

# # terraform plan

# # terraform apply --auto-approve
# # sleep 2

# # #rm -rf .terraform*

# cd $rootPath

# cp terraform/modules/02-eks/scripts/kubeconfig-test terraform/configurator/kubeconfig/