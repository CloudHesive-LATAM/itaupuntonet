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
                      # PASO 0 
                      # CICD account 

                      # Assume (Development account) role and load variables to Initialize Terraform backend
                      set +x
                     
                        export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws sts assume-role --role-arn "arn:aws:iam::137985267002:role/crossaccount-pipe" --role-session-name MySessionName --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
                        
                        echo " Role has been assumed DEV" 

                        # PASO 1 - Dev Account crossaccount-pipe
                        # DEV account 
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
                      
                      terraform plan -out tfplan.binary 
                      terraform show -json tfplan.binary > tfplan.json

                      echo " ------------ INFRACOST ------------ "
                      set +x
                        export INFRACOST_API_KEY="uSEQ1Iyc8xkSAWzEnn9ZrNOffDCnQg7t"
                      set -x
                      
                      
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

                      bucketname="itaunetinfrasandbox"
                      keyfile="terraform.tfstate"
                      echo " ------------ DRIFTCTL ------------ "
                      driftctl scan --from tfstate+s3://$bucketname/$keyfile > driftctl_info.txt || echo "driftcl run successfully" 
                      sleep 5
                      cat driftctl_info.txt
                      

                      # TFSEC (Vulnerability Analysys) 
                      echo " ------------ TF SEC ------------ "
                      tfsec . > tfsec_info.txt || echo "TFSec run successfully" 
                      cat tfsec_info.txt
                      sleep 5

                      echo " ------------ REGULA ------------ "
                      # REGULA (Open Policy Agent (OPA) project - Policy-based control for cloud native environments)
                      regula run > regula_info.txt || echo "Regula run successfully" 
                      cat regula_info.txt
                      sleep 5
                      
                      echo " ------------ TF DOCS ------------ "
                      # dinamically Markdown md documentation (based on IaC code) 
                      terraform-docs markdown . > tfdocs.md || echo "TF DOCS run successfully"
                      cat tfdocs.md
                      sleep 5 

                      terraform apply -auto-approve
                      
                    '''
                }
            }

    }


        
}
}


