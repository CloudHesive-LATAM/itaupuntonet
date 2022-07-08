terraform {
  

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.0"
      configuration_aliases = [aws, aws.sts_shared_account]
    }
  }
}

data "aws_caller_identity" "parent" {
  provider = aws
}

output "account_id_parent" {
  value = data.aws_caller_identity.parent.account_id
}

data "aws_caller_identity" "child" {
  provider = aws.sts_shared_account
}

output "account_id_child" {
  value = data.aws_caller_identity.child.account_id
}

