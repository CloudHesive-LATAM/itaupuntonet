
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws --profile cicd-consorcio sts assume-role --role-arn arn:aws:iam::250412402401:role/STSBaseRoleFromCICDEc2RunnerToGeneralCICDPipelines --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts assume-role --role-arn arn:aws:iam::839093138397:role/BBPipelineAccessToDev --role-session-name MySessionName2 --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
aws sts get-caller-identity
aws eks update-kubeconfig --name EKS-Cluster-Master-development-main --region us-east-1