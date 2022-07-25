terraform {


  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.0"
      configuration_aliases = [aws, aws.sts_security_account]
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }


    # tls = {
    #   source = "hashicorp/tls"
    #   version = "3.4.0"
    # } 
  }
}

