# data "aws_subnet" "subnet" {
#   count = var.eks_worker_spot["spot"] == "SPOT" ? 1 : 0
#   id    = var.private_subnets[0]
# }
#
#data "aws_ec2_spot_price" "spot_current_price" {
#  count             = var.eks_worker_spot["spot"] == "SPOT" ? 1 : 0
#  instance_type     = var.instance_type["dev_env"]
#  availability_zone = data.aws_subnet.subnet[0].availability_zone
#
#  filter {
#    name   = "product-description"
#    values = ["Linux/UNIX"]
#  }
#}
#
