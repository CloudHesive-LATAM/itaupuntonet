resource "random_password" "master"{
  provider = random
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  provider = aws.sts_shared_account
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "password" {
  provider = aws.sts_shared_account
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}