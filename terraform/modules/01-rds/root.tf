# Secret in Secrets Manager Shared account

resource "random_password" "master" {
  
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  provider = aws.sts_shared_account # shared
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "password" {
  provider = aws.sts_shared_account # shared
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}


# RDS Intance

data "aws_secretsmanager_secret" "password" {
  provider = aws.sts_shared_account
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "password" {
  provider = aws.sts_shared_account
  secret_id = data.aws_secretsmanager_secret.password
}

resource "aws_db_instance" "postgrespuntonet" {
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
