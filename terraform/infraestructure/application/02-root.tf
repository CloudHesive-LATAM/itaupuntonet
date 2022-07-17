module "networking" {
  providers = {
    # el normal para el hijo, es el asumido por el root
    aws = aws.sts_destination_account
    aws.sts_security_account = aws.sts_security_account
    random = random
  } 
  count = var.create_nw == true ? 1 : 0
  source            = "../modules/networking"
  region            = var.aws_region["virginia"]
  project-tags      = var.project-tags
  resource-name-tag = "Consorcio-Nw"
  tgw_id = var.tgw_id
 
}

module "eks" {
  
  providers = {
    # el normal para el hijo, es el asumido por el root
    aws = aws.sts_destination_account
    aws.sts_security_account = aws.sts_security_account
    random = random
  } 

  use_precreated_kms_encryption_key = var.use_precreated_kms_encryption_key
  kms_encryption_arn = var.kms_encryption_arn
  source            = "../modules/eks"
  vpc_id = var.create_nw == true ? module.networking.vpc_id : var.nw_configurations["vpc_id"]
  project-tags      = var.project-tags
  resource-name-tag = "eks-"
  private_subnets =  var.create_nw == true ? module.networking.private_subnets : var.nw_configurations["private_subnets"]
  
}
