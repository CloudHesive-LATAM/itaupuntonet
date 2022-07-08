terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
 
  }

  backend "s3" {
    
  }
}

provider "aws" {
  region     = var.aws_region
  # DEV

}

# SET STS SHARED ALIAS ACCOUNT TO BE ASSUMED
provider "aws" {
  # SHARED 
  region     = var.aws_region
  alias = "sts_shared_account"
  assume_role {
    role_arn = var.role_arn_sts_shared
    session_name = "test"
  }

}

