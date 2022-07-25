# Create Security Group
resource "aws_security_group" "worker_ec2_sg" {



  name        = var.ec2_sg
  description = "AWS security group for ec2 instances"
  vpc_id      = var.vpc_id

  # Input
  ingress {
    from_port   = 1
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Output
  egress {
    from_port   = 0             # any port
    to_port     = 0             # any port
    protocol    = "-1"          # any protocol
    cidr_blocks = ["0.0.0.0/0"] # any destination
  }


  tags = merge(
    {
      Name = "EC2_sg",
    },
    var.project-tags,
  )
}