//https://gist.github.com/johann8384/3e3bf47d4535546d180807c00fbb71a7
pipeline {
    agent {

    kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: prueba
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
                    ls -lah 
                    
                    '''
                }
            }

    }


        
}
}


