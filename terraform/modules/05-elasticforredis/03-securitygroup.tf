resource "aws_security_group" "EKS_SG" {
  name        = var.name_redis
  description = "Security group for redis"
  vpc_id      = var.vpc_id

  ingress {
      description = "Allow Ingress ALL from VPC CIDR"
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = ["10.159.53.128/25"]
    }

  ingress {
      description = "Allow Ingress ALL from VPC CIDR"
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = ["10.159.53.0/25"]
    }

  # opcional
  egress {
    description      = "Allow Internet Out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}