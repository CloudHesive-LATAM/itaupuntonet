//https://gist.github.com/johann8384/3e3bf47d4535546d180807c00fbb71a7
pipeline {
    agent {

    kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
  - name: tfrunner
    image: 793764525616.dkr.ecr.us-east-1.amazonaws.com/terraform-runner:1.0
    imagePullPolicy: Always
    command:
      - sleep
    args:
      - 99d
    ttyEnabled: true,  
      '''
        }
    }

    stages {

        
        stage('S3 State creation') {
            steps {
                container('tfrunner') {
                  sh '''
                    
                      # Assume role and load variables

                      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts assume-role --role-arn "arn:aws:iam::137985267002:role/crossaccount-pipe" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
                      
                      # Execute script to create S3 Bucket for remote backend in case it is not already created
                      
                      sh terraform/infraestructure/s3_state/creator_script.sh
                      
                    '''
                }
            }

    }

        stage('Creation of secrets Security Account') {
            steps {
                container('tfrunner') {
                  sh '''
                    
                      # Assume Development account role and load variables to Initialize Terraform backend

                      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts assume-role --role-arn "arn:aws:iam::137985267002:role/crossaccount-pipe" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))

                      cd terraform/infraestructure/application
                      terraform init \
                          -backend-config="bucket=itaunetinfrasandbox" \
                          -backend-config="key=terraform.tfstate" \
                          -backend-config="region=us-east-1" \
                          -backend-config="dynamodb_table=terraform-locks-itau-puntonet" \
                          -backend-config="encrypt=true"
                      
                      # Assume Shared account role and create DB credentials Secret Manager Shared account
                      
                      terraform plan
                      terraform apply -auto-approve
                      
                    '''
                }
            }

    }


        
}
}


