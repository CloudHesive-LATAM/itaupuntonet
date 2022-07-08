# module "rds" {
#   source            = "../../modules/rds"
  
#   allocated_storage    = "100"
#   engine               = "14.1"
#   engine_version       = "postgres"
#   instance_class       = "m5.large"
#   name                 = "itaupuntonet"
#   username             = "dbadmin"
#   password             = data.aws_secretsmanager_secret_version.password
#   parameter_group_name = "default"
#   skip_final_snapshot  = true

# }


# provider "aws" {
#   region = "us-east-2"
#   alias  = "parent"
# }

# provider "aws" {
#   region = "us-east-2"
#   alias  = "child"

#   assume_role {
#     role_arn = var.child_iam_role_arn
#   }
# }

# TOMAR DATA PARA VER Q SE PUEDA ASUMIR EL ROL
# data "aws_caller_identity" "parent" {
#   provider = aws
# }

# data "aws_caller_identity" "child" {
#   provider = aws.sts_shared_account

# }

# output "account_id_child" {
#   value = data.aws_caller_identity.child.account_id
# }

# output "account_id_parent" {
#   value = data.aws_caller_identity.parent.account_id
# }


module "rds_credentials" {
   source            = "../../modules/02-rds_credentials"
   providers = {
     aws = aws
     aws = aws.sts_shared_account
   }
}
