resource "aws_security_group" "Endpoint_SG" {
  
  name        = "VPC-ENDPOINT-SG"
  description = "VPC-ENDPOINT-SG"
  vpc_id      = aws_vpc.poc_vpc.id
    ingress {
      description = "Allow Ingress 443 from VPC CIDR"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      #cidr_blocks = ["0.0.0.0/0"]
      cidr_blocks = [aws_vpc.poc_vpc.cidr_block]
    }

  egress {
    description      = "Allow ALL outbound Traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-SG" }, )
}

resource "aws_security_group" "database_instance" {
  
  name        = "database_access" 
  description = "Allow RDS Instance acces from EKS Subnets"
  vpc_id      = aws_vpc.poc_vpc.id
    ingress {
      description = "Allow RDS Instance acces from EKS Subnets"
      from_port   = 0
      to_port     = 5432
      protocol    = "tcp"
      #cidr_blocks = ["0.0.0.0/0"]
      cidr_blocks = [aws_subnet.poc_private[0].cidr_block, aws_subnet.poc_private[1].cidr_block ]
    }

  egress {
    description      = "Allow ALL outbound Traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-SG" }, )
}