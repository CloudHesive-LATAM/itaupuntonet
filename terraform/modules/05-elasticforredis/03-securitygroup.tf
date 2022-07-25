resource "aws_security_group" "redis_sg" {
  name        = var.name_redis
  description = "Security group for redis"
  vpc_id      = "vpc-00d829652c07a10dd"

  ingress {
    description = "Allow Ingress ALL from VPC CIDR"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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