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
    #image: 793764525616.dkr.ecr.us-east-1.amazonaws.com/terraform-runner:1.0
    image: ncavasin/full-awscli
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
                    
                      # Assume role (TO DEV) and load variables (hiding variables)
                      set +x
                      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts assume-role --role-arn "arn:aws:iam::137985267002:role/crossaccount-pipe" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
                      
                      echo $(aws sts get-caller-identity)
                      # Execute script to create S3 Bucket for remote backend in case it is not already created
                      
                      sh terraform/infraestructure/s3_state_creation/creator_script.sh "itaunetinfrasandbox" "terraform-locks-itau-puntonet"
                      
                    '''
                }
            }

    }

        stage('Creation of secrets Security Account') {
            steps {
                container('tfrunner') {
                  sh '''
                    
                      # Assume (Development account) role and load variables to Initialize Terraform backend
                      set +x
                     
                      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts assume-role --role-arn "arn:aws:iam::137985267002:role/crossaccount-pipe" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
                      
                      echo " Role has been assumed DEV" 
                      echo $(aws sts get-caller-identity)
                      
                      set -x

                      cd terraform/infraestructure/application
                      terraform init \
                          -backend-config="bucket=itaunetinfrasandbox" \
                          -backend-config="key=terraform.tfstate" \
                          -backend-config="region=us-east-1" \
                          -backend-config="dynamodb_table=terraform-locks-itau-puntonet" \
                          -backend-config="encrypt=true"
                      
                      # Assume Shared account role and create DB credentials Secret Manager Shared account
                      
                      # ---- INFRACOST -----
                      export INFRACOST_API_KEY="uSEQ1Iyc8xkSAWzEnn9ZrNOffDCnQg7t"
                      # TOTAL
                      infracost breakdown --path=. > infracost_totalcost.txt
                      # DIFF
                      infracost diff --path=tfplan.json > infracost_diff.txt
                      
                      cat infracost_totalcost.txt
                      echo " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "
                      sleep 5
                      cat infracost_diff.txt
                      #terraform plan
                      # VAR PRECEDENDE: https://spacelift.io/_next/image?url=https%3A%2F%2Fspaceliftio.wpcomstaging.com%2Fwp-content%2Fuploads%2F2022%2F05%2Fimage8-2.png&w=1920&q=75

                      #terraform apply -auto-approve
                      
                    '''
                }
            }

    }


        
}
}


