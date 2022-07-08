resource "random_password" "master"{
  
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

resource "aws_s3_bucket" "terraform_state" {
  provider = aws
  bucket = "fafaidfaseiufdxszoivjasidofuasd12321dfdf3"

  lifecycle {
    prevent_destroy = true
  }
}