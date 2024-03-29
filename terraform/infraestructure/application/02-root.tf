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


module "rds_credentials" {
   source            = "../../modules/02-rds_credentials"
   providers = {
     aws = aws # cuenta dev
     aws.sts_shared_account = aws.sts_shared_account # cuenta shared / security
     random = random # extras
     
   }
}
