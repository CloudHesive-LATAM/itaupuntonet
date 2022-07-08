data "aws_secretsmanager_secret" "password" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "password" {
  secret_id = data.aws_secretsmanager_secret.password
}

resource "aws_db_instance" "postgrespuntonet" {
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