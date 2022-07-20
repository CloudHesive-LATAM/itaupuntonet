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



# data "aws_secretsmanager_secret" "password" {
#   provider = aws.sts_security_account
#   name = var.secret_name

# }

# data "aws_secretsmanager_secret_version" "passworddb" {
#   provider = aws.sts_security_account
#   secret_id = data.aws_secretsmanager_secret.password.id
# }



# data "external" "helper" {
#   program = ["echo", "${replace(data.aws_secretsmanager_secret_version.password.secret_string, "\\\"", "\"")}"]
# }


#Obtener id de la VPC creada en el modulo anterior

data "aws_vpcs" "application_vpc" {
  tags = {
    CC = "architecture",
    idApp = "1",
    env = "dev",
    responsible = "CH"
    project = "migrationpath"
    Name = "ItauPuntoNet-Nw-vpc-b"
  }
}

# Obtener ids de las subredes de base de datos creadas en el modulo anterior

# data "aws_subnet_ids" "privatedbsubnets" {
#   vpc_id = data.aws_vpcs.application_vpc
# }

resource "aws_db_subnet_group" "group_subnet" {
  name       = "grupo-subnet-db"
  subnet_ids = var.subnet_ids #data. [aws_subnet.poc_public[0].id, aws_subnet.poc_public[1].id]
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
  password             = random_password.master.result #jsondecode(data.aws_secretsmanager_secret_version.passworddb.secret_string) 
  parameter_group_name = "default"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.group_subnet.name
}
