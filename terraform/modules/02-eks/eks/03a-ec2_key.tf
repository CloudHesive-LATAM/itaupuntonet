
# [STEP 1] - Create and store (locally pem key)
resource "tls_private_key" "algorithm_conf" {
  
  

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2-key" {
    

    key_name   = var.eks_nodes_key
    public_key = tls_private_key.algorithm_conf.public_key_openssh

    provisioner "local-exec" { # Create "myKey.pem" to your computer!!
        command = "echo '${tls_private_key.algorithm_conf.private_key_pem}' > '${path.module}'/ec2-key.pem ; echo '${tls_private_key.algorithm_conf.public_key_pem}' > '${path.module}'/ec2-key_pub.pem"
        
    }

    tags = {
        Name = "EC2-KEY-${var.eks_nodes_key}"
    }
}

# # [STEP 2] - Store also in SSM
# Encriptar el secret con kms.

resource "aws_secretsmanager_secret" "ec2-ssm-key" {
  
  
  name = "ec2-ssm-test"
  
  provider = aws.sts_security_account
  # Si es por kms security usa el arn de esa llave.
  kms_key_id = var.use_precreated_kms_encryption_key == true ? var.kms_encryption_arn : null
}

resource "aws_secretsmanager_secret_version" "ec2-ssm-key-secret" {
  
  provider = aws.sts_security_account
  secret_id     = aws_secretsmanager_secret.ec2-ssm-key.id
  secret_string = tls_private_key.algorithm_conf.private_key_pem
 
}

