# Create EFS
resource "aws_efs_file_system" "webapp" {
  creation_token = "my-product"
  encrypted = var.encrypted
  performance_mode = var.performance_mode["generalpurpose"]
  throughput_mode = var.throughput_mode["bursting"]
  kms_key_id = aws_kms_key.webapp.arn

  tags                    = { Name = "${var.name-efs}-efs" }
}

# Create the KMS Key
resource "aws_kms_key" "webapp" {
  description             = "S3 Encryption Key"
  deletion_window_in_days = 15
  multi_region            = false
  tags                    = { Name = "${var.kms-name}-kms-key" }
}