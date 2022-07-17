resource "aws_security_group" "EKS_SG" {
  
  

  name        = var.aws_eks_sg
  description = var.aws_eks_sg_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ports_list
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr"]
    }
  }

  #creo que esto no hace falta, xq es opcional
  egress {
    description      = "Allow Internet Out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}