terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
 
  }

  backend "s3" {
    
  }
}

provider "aws" {
  region     = var.region
  assume_role {
    
    role_arn = var.role_arn
  }

}
