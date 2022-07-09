module "rds" {
  source            = "../../modules/01-rds"
  providers = {
     aws = aws # cuenta dev
     aws.sts_shared_account = aws.sts_shared_account # cuenta shared / security
     random = random # extras
  }

  allocated_storage    = var.allocated_storage 
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name
  username             = var.username
  password             = data.aws_secretsmanager_secret_version.password
  parameter_group_name = "default"
  skip_final_snapshot  = true

}
