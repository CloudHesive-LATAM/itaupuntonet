terraform {
  

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.0"
      configuration_aliases = [aws.sts_dev_account, aws.sts_shared_account]
    }
    
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  
}

