module "networking" {
  providers = {
    aws                      = aws
    aws.sts_security_account = aws.sts_security_account
    random                   = random
  }
  count             = var.create_nw == true ? 1 : 0
  source            = "../../modules/03-networking"
  region            = var.aws_region["virginia"]
  project-tags      = var.project-tags
  resource-name-tag = "Prueba-Nw" # Variabilizar
  tgw_id            = var.tgw_id
  create_public_nw  = var.create_public_nw
}


module "eks" {
  depends_on = [
    module.networking
  ]
  source = "../../modules/02-eks"

  providers = {
    # el normal para el hijo, es el asumido por el root
    #aws = aws.sts_destination_account
    aws                      = aws
    aws.sts_security_account = aws.sts_security_account
    random                   = random
    local                    = local
    #tls = tls
  }

  use_precreated_kms_encryption_key = var.use_precreated_kms_encryption_key
  kms_encryption_arn                = var.kms_encryption_arn

  vpc_cidr_block      = var.create_nw == true ? module.networking[0].vpc_id : null
  vpc_id              = var.create_nw == true ? module.networking[0].vpc_id : var.nw_configurations["vpc_id"]
  project-tags        = var.project-tags
  resource-name-tag   = "eks-"
  app_private_subnets = var.create_nw == true ? module.networking[0].private_subnets : var.nw_configurations["app_private_subnets"]
}

module "rds" {

  depends_on = [
    module.networking
  ]

  providers = {
    aws                      = aws
    aws.sts_security_account = aws.sts_security_account
    random                   = random
  }

  source = "../../modules/01-rds"

  subnet_ids = var.nw_configurations["db_database_subnets"]
  cidr_block = var.cidr_block
  vpc_id     = var.nw_configurations["vpc_id"]

  # subnet_ids = module.networking[0].private_subnets_db
  # sgid_database = module.networking[0].sgid_database


}


module "redis" {
  providers = {
    aws                      = aws
    aws.sts_security_account = aws.sts_security_account
    random                   = random
  }
  source     = "../../modules/05-elasticforredis"
  cidr_block = var.cidr_block
  vpc_id     = var.nw_configurations["vpc_id"]

} 