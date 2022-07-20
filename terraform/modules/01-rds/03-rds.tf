# Secret in Secrets Manager Shared account

resource "random_password" "master" {
  
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  provider = aws.sts_security_account # shared
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "password" {
  provider = aws.sts_security_account # shared
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
  #secret_string = <<EOF
  #{"rds_password": "${random_password.master.result}"} 
  #EOF
}



# RDS Intance

# locals {
#   your_secret = jsondecode(
#     data.aws_secretsmanager_secret_version.password.secret_string
#   )
# }



data "aws_secretsmanager_secret" "password" {
  provider = aws.sts_security_account
  name = var.secret_name

}

data "aws_secretsmanager_secret_version" "password" {
  provider = aws.sts_security_account
  secret_id = data.aws_secretsmanager_secret.password
}

resource "aws_db_instance" "db_engine" {
  depends_on = [
    aws_secretsmanager_secret_version.password    
  ]
  provider = aws #Dev
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
