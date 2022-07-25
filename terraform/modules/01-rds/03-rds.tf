# Secret in Secrets Manager Shared account

resource "random_password" "master" {

  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  provider = aws.sts_security_account # shared
  name     = var.secret_name
}

resource "aws_secretsmanager_secret_version" "password" {
  provider      = aws.sts_security_account # shared
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}


resource "aws_db_subnet_group" "group_subnet" {
  name       = "grupo-subnet-db"
  subnet_ids = var.subnet_ids #data. [aws_subnet.poc_public[0].id, aws_subnet.poc_public[1].id]
}

resource "aws_db_instance" "db_engine" {
  depends_on = [
    aws_secretsmanager_secret_version.password
  ]
  provider               = aws #Dev
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.name
  username               = var.username
  password               = random_password.master.result #jsondecode(data.aws_secretsmanager_secret_version.passworddb.secret_string) 
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.group_subnet.name
  vpc_security_group_ids = [aws_security_group.database_instance.id]

}

resource "aws_security_group" "database_instance" {

  name        = "database_access"
  description = "Allow RDS Instance acces from EKS Subnets"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow RDS Instance acces from EKS Subnets"
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["10.159.53.128/25"] #element([var.cidr_block], 0)
  }

  ingress {
    description = "Allow RDS Instance acces from EKS Subnets"
    from_port   = 0
    to_port     = 5432
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["10.159.53.0/25"] #element([var.cidr_block], 1)
  }

  egress {
    description      = "Allow ALL outbound Traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-SG" }, )
}
