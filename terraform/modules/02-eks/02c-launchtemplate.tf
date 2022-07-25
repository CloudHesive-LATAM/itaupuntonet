# If i wanna ask for Spot Fleet:
##  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_fleet_request


# Empty or non empty
# https://medium.com/@business_99069/terraform-0-12-conditional-block-7d166e4abcbf
# gotchas: https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9#0223

# Worker autoscalers o ManageNodeGroups
# https://blog.kubernauts.io/hey-docker-run-eks-with-auto-fleet-spotting-support-please-f91fcc80c60e
#locals {
#
#  # try catch
#  spot_price = try(data.aws_ec2_spot_price.spot_current_price[0].spot_price + data.aws_ec2_spot_price.spot_current_price[0].spot_price * 0.02, 0)
#
#}

# [STEP 1] - Create AWS Launch Template (IF SPOT)
resource "aws_launch_template" "ec2_for_eks" {



  # depends_on = [
  #   data.aws_ec2_spot_price.spot_current_price
  # ]

  # IF SPOT SET = 1 , deploy using spot
  name = "LT-Default"
  #image_id = "ami-0c6f20e00e2f5869a"
  instance_type = var.instance_type["dev_env"]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.eks_worker_spot["ssd_size"]
    }
  }

  update_default_version = true                          #Actualiza default_version a la última_versión en terraform apply 
  key_name               = aws_key_pair.ec2-key.key_name # Reemplazar por la de Cuenta Security


  monitoring {
    enabled = var.eks_worker_spot["monitoring"]
  }

  #vpc_security_group_ids = [aws_security_group.worker_ec2_sg.id]


  # instance_market_options {
  #   market_type = "spot"

  #   spot_options {

  #         instance_interruption_behavior = var.eks_worker_spot["instance_interruption_behavior"]
  #         max_price                      = local.spot_price
  #         spot_instance_type             = var.eks_worker_spot["spot_type"]
  #   }
  # }

  # dynamic "instance_market_options" {
  #   for_each = var.eks_worker_spot["spot"] == true ? [1] : []

  #   content {
  #       market_type = "spot"

  #       spot_options {

  #           #instance_interruption_behavior = var.eks_worker_spot["instance_interruption_behavior"]
  #           #max_price                      = local.spot_price
  #           #spot_instance_type             = var.eks_worker_spot["spot_type"]
  #       }
  #   }

  # }



  #user_data = filebase64("${path.module}/scripts/userdata.sh")

}


# [STEP 2] - Retrieve data as variable
data "aws_launch_template" "ec2_for_eks" {



  name       = aws_launch_template.ec2_for_eks.name
  depends_on = [aws_launch_template.ec2_for_eks]
}
## [STEP 3] - Definir DATA AMI QUERY :)

