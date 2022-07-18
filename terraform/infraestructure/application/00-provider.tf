# Providers config
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10.0"
    }
  
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  backend "s3" {
    
  }
}

# Default provider, it will be used when no provider is declared in the resource.
# provider "aws" {
#   region  = var.aws_region["virginia"]
#   profile = var.aws_provider_profile
# }

# Default provider, it will be used when no provider is declared in the resource.

## Tenemos los 3 layers
# Layer 1 : Cuenta CICD
# Layer 2 : Cuenta destino (Dev)
# Layer 3 : Cuenta security / Shared -> centralizador de keys, kms, kubeconfig. 


provider "aws" {
  # Cuenta CICD default
  region     = var.aws_region["virginia"]
}

# provider "aws" {
#   # Cuenta Destino (dev)
#   alias = "sts_destination_account"
#   region     = var.aws_region["virginia"]
#   assume_role {
    
#     role_arn = var.role_arn_destination_account
#   }

# }

provider "aws" {
  # Cuenta Shared/security 
  alias = "sts_security_account"
  region     = var.aws_region["virginia"]
  assume_role {
    
    role_arn = var.role_arn_security_account
  }

}


# STS assume
# https://medium.com/hackernoon/terraform-with-aws-assume-role-21567505ea98
# https://support.hashicorp.com/hc/en-us/articles/360041289933-Using-AWS-AssumeRole-with-the-AWS-Terraform-Provider

/* provider "aws" {
  
  # The security credentials for AWS Account A.
  region  = var.aws_region["virginia"]
  # profile = var.aws_provider_profile
  alias = "sts-shared-security"
    assume_role {
    
    role_arn = var.role_arn
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
# Provider for Source Bucket */
#provider "aws" {
#  alias   = "source"
#  region  = var.aws_region["virginia"]
#  profile = var.aws_provider_profile
#}
#
## Provider for Destination Bucket
#provider "aws" {
#  alias   = "destination"
#  region  = var.aws_region["oregon"]
#  profile = var.aws_provider_profile
#}




