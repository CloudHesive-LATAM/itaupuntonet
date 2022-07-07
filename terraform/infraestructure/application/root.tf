# module "rds" {
#   source            = "../../modules/rds"
  
#   allocated_storage    = "100"
#   engine               = "14.1"
#   engine_version       = "postgres"
#   instance_class       = "m5.large"
#   name                 = "itaupuntonet"
#   username             = "dbadmin"
#   password             = data.aws_secretsmanager_secret_version.password
#   parameter_group_name = "default"
#   skip_final_snapshot  = true

# }

module "rds_credentials" {
   source            = "../../modules/rds_credentials"
}

# module "eks" {
#   # We have to clavate alias name
#   providers = {
#     aws.sts-shared-security = aws.sts-shared-security
#   }
#   use_precreated_kms_encryption_key = var.use_precreated_kms_encryption_key
#   kms_encryption_arn = var.kms_encryption_arn
#   source            = "../modules/eks"
#   vpc_id = var.create_nw == true ? module.networking.vpc_id : var.nw_configurations["vpc_id"]
#   project-tags      = var.project-tags
#   resource-name-tag = "eks-"
#   private_subnets =  var.create_nw == true ? module.networking.private_subnets : var.nw_configurations["private_subnets"]
# }
# # # [STEP 2] - Store also in SSM
# resource "aws_secretsmanager_secret" "ec2-ssm-key" {
#   name = "ec2-ssm-key2"
#   provider = aws.sts-shared-security
#   kms_key_id = var.use_precreated_kms_encryption_key == true ? var.kms_encryption_arn : null
# }