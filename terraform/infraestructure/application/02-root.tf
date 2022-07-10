module "rds" {
  source            = "../../modules/01-rds"
  providers = {
     aws.sts_dev_account = aws.sts_dev_account # cuenta dev
     aws.sts_shared_account = aws.sts_shared_account # cuenta shared / security
     random = random # extras
  }

  secret_name          = "itaunetsecretsandbox"

  allocated_storage    = "100"
  engine               = "postgres"
  engine_version       = "14.1"
  instance_class       = "m5.small"
  name                 = "itaupuntonet"
  username             = "dbadmin"

}
