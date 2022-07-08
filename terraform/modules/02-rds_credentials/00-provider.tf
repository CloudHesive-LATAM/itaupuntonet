terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
 
  }

  
}

provider "aws" {
  region     = "us-east-1"
}

# SET STS SHARED ALIAS ACCOUNT TO BE ASSUMED
provider "aws" {
  region     = var.aws_region
  alias = "sts_shared_account"
  assume_role {
    role_arn = "arn:aws:iam::635304474566:role/pipeline-secrets-crossaccount"
    session_name = "test"
  }

}
