#-------------------------------------
# VPCE Definition INTERFACE
#------------------------------------

resource "aws_vpc_endpoint" "poc_vpce_1" {
  
  vpc_id       = aws_vpc.poc_vpc.id
  service_name = "com.amazonaws.${var.region}.sts"
  # service_name      = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.poc_private[1].id]
  security_group_ids = [
    aws_security_group.Endpoint_SG.id,
  ]
  private_dns_enabled = true
  tags                = merge(var.project-tags, { Name = "${element(var.vpcEndpoint, 0)}-Endpoint" }, )
}

resource "aws_vpc_endpoint" "poc_vpce_2" {
  
  vpc_id            = aws_vpc.poc_vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.poc_private[1].id]
  security_group_ids = [
    aws_security_group.Endpoint_SG.id,
  ]
  private_dns_enabled = true
  tags                = merge(var.project-tags, { Name = "${element(var.vpcEndpoint, 1)}-Endpoint" }, )
}

resource "aws_vpc_endpoint" "poc_vpce_3" {
  
  vpc_id            = aws_vpc.poc_vpc.id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.poc_private[1].id]
  security_group_ids = [
    aws_security_group.Endpoint_SG.id,
  ]

  tags = merge(var.project-tags, { Name = "${element(var.vpcEndpoint, 2)}-Endpoint" }, )
}

resource "aws_vpc_endpoint" "poc_vpce_4" {
  
  vpc_id            = aws_vpc.poc_vpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.poc_private[1].id]
  security_group_ids = [
    aws_security_group.Endpoint_SG.id,
  ]
  private_dns_enabled = true
  tags                = merge(var.project-tags, { Name = "${element(var.vpcEndpoint, 3)}-Endpoint" }, )
}

resource "aws_vpc_endpoint" "poc_vpce_5" {
  
  vpc_id            = aws_vpc.poc_vpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.poc_private[1].id]
  security_group_ids = [
    aws_security_group.Endpoint_SG.id,
  ]
  private_dns_enabled = true
  tags                = merge(var.project-tags, { Name = "${element(var.vpcEndpoint, 4)}-Endpoint" }, )
}


resource "aws_vpc_endpoint" "poc_vpce_6" {
  
  vpc_id            = aws_vpc.poc_vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.poc_private[1].id]
  security_group_ids = [
    aws_security_group.Endpoint_SG.id,
  ]
  private_dns_enabled = true
  tags                = merge(var.project-tags, { Name = "${element(var.vpcEndpoint, 5)}-Endpoint" }, )
}

resource "aws_vpc_endpoint" "poc_vpce_7" {
  
  vpc_id            = aws_vpc.poc_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.poc_private[1].id]
  security_group_ids = [
    aws_security_group.Endpoint_SG.id,
  ]
  private_dns_enabled = true
  tags                = merge(var.project-tags, { Name = "${element(var.vpcEndpoint, 6)}-Endpoint" }, )
}

resource "aws_vpc_endpoint" "poc_vpce_8" {
  
  vpc_id            = aws_vpc.poc_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.poc_private[1].id]
  security_group_ids = [
    aws_security_group.Endpoint_SG.id,
  ]
  private_dns_enabled = true
  tags                = merge(var.project-tags, { Name = "${element(var.vpcEndpoint, 7)}-Endpoint" }, )
}

#-------------------------------------
# VPCE Definition GATEWAY
#------------------------------------

resource "aws_vpc_endpoint" "poc_vpce_12" {
  
  vpc_id            = aws_vpc.poc_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  tags = merge(var.project-tags, { Name = "${var.vpcEndpoint[0]}-Endpoint" }, )
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  
  route_table_id  = aws_route_table.private_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.poc_vpce_12.id
}
