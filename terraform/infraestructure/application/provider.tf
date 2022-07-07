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
  region     = var.aws_region

}

provider "aws" {
  region     = var.aws_region
  alias = "cuenta-shared"

}
provider "aws" {
  # The security credentials for AWS Account A.
  region  = var.aws_region["virginia"]
  # profile = var.aws_provider_profile
  alias = "sts-shared-security"
    assume_role {
    role_arn = var.role_arn_sts_shared
  }
  # (Optional) the MFA token for Account A.
  # token      = "123456"
  # assume_role {
  #   # The role ARN within Account B to AssumeRole into. Created in step 1.
  #   role_arn    = var.sts["role"]
  #   # (Optional) The external ID created in step 1c.
  #   #external_id = "my_external_id"
  #   session_name = var.sts["session_name"]
  # }
}
