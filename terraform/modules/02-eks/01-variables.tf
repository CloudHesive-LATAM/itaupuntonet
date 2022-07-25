## EKS specific resources
variable "eks_non_admin_IAM_policy_definition" {
  type = object({
    name    = string
    effect  = string
    actions = list(string)

    identifiers = list(string)
  })

  default = {
    name        = "EKS-Non-Admin-Policy"
    effect      = "Allow"
    actions     = ["eks:*"]
    identifiers = ["*"]

  }
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR Block"

}

variable "app_private_subnets" {
  type        = list(string)
  description = "Private Subnets"
  default     = []
}

variable "destination_account" {
  type        = string
  description = "destination account to be used as parameter"
  default     = "308582334619"
}

variable "cicd_account" {
  type        = string
  description = "destination account to be used as parameter"
  default     = "793764525616"
}

variable "cicd_role" {
  type        = string
  description = "Role to be used to 'jump' to destination account and be able to consume EKS"
  default     = "STSBaseRoleFromCICDEc2RunnerToGeneralCICDPipelines"
}

variable "eks_non_admin_IAM_STS_policy" {
  default = {
    name    = "EKS-Non-Admin-STS-policy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    type    = "AWS"


  }
  type = object({
    name    = string
    effect  = string
    actions = list(string)
    type    = string


  })
}

variable "eks_environment" {
  type    = string
  default = "development"
}

variable "eks_application_definition" {
  type    = string
  default = "main"

}

variable "private_subnets" {
  type        = list(string)
  description = "Private Subnets"
  default     = []
}




# [STEP 1] - Define IAM Policy Parameters (this is gonna be used in Policy-Roles EKS)
# Comienzo de declaración de variables para archivo 02-iam_role.tf
variable "eks_master_IAM_policy_parameters" {
  # Default value
  default = {
    name        = "EKS-Cluster-Master"
    effect      = "Allow"
    actions     = ["sts:AssumeRole"]
    type        = "Service"
    identifiers = ["eks.amazonaws.com"]                                # <- STS Policy (document policy)
    policies    = ["AmazonEKSClusterPolicy", "AmazonEKSServicePolicy"] # <- AWS Managed Policies 

  }

  # Or wait for user defined data
  type = object({
    name        = string
    effect      = string
    actions     = list(string)
    type        = string
    identifiers = list(string)
    policies    = list(string)

  })
}

variable "eks_worker_IAM_policy_parameters" {
  default = {
    name        = "EKS-Cluster-Worker"
    effect      = "Allow"
    actions     = ["sts:AssumeRole"]
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
    policies    = ["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly", "CloudWatchFullAccess", "AmazonSSMManagedInstanceCore", "service-role/AmazonEC2RoleforSSM"]
  }
  type = object({
    name        = string
    effect      = string
    actions     = list(string)
    type        = string
    identifiers = list(string)
    policies    = list(string)
  })
}
##
## Fin de variables para 02a-iam_roles.tf
################################

## COmienzo de variables para eks-sg
#
variable "aws_eks_sg" {
  type    = string
  default = "eks-cluster-sg-EKS"
}
variable "aws_eks_sg_description" {
  type    = string
  default = "Grupo de seguridad de EKS"
}

variable "sg_ports_list" {
  type = list(object({
    port     = number
    protocol = string
    cidr     = list(string)

  }))
  default = [
    {
      port     = 31103
      protocol = "tcp"
      cidr     = ["0.0.0.0/0"]
    },
    {
      port     = 443
      protocol = "tcp"
      cidr     = ["10.20.227.48/32"]
    },
    {
      port     = 30128
      protocol = "tcp"
      cidr     = ["0.0.0.0/0"]
    },
    {
      port     = 30614
      protocol = "tcp"
      cidr     = ["0.0.0.0/0"]
    },
    {
      port     = 30301
      protocol = "tcp"
      cidr     = ["10.180.0.0/24", "10.180.1.0/24", "10.180.2.0/24"]
    },
  ]
}

## comienzo de variables para eks
variable "eks_ng_name" {
  type    = string
  default = "EKS-NG-Test"
}

variable "ng_scaling_config" {
  type = map(string)
  default = {
    desired_size = 1
    max_size     = 50
    min_size     = 0
  }
}

variable "kms_encryption_arn" {
  type        = string
  description = "ARN of ksm key to apply Secret Manager"

}

variable "use_precreated_kms_encryption_key" {
  type        = bool
  description = "Use or not KMS"

}


variable "eks_worker_spot" {
  type = object({
    spot                           = string
    spot_price                     = number
    wait_for_fulfillment           = bool
    spot_type                      = string
    tag                            = string
    instance_interruption_behavior = string
    spot_increment                 = number
    ssd_size                       = number
    monitoring                     = bool
  })
  # spot_price -> max 
  default = {
    spot                           = "SPOT" #SPOT, ON_DEMAND
    spot_price                     = 1
    wait_for_fulfillment           = true
    spot_type                      = "one-time"
    tag                            = "cheap worker"
    instance_interruption_behavior = "terminate"
    spot_increment                 = 0.1
    ssd_size                       = 20
    monitoring                     = true

  }
}

/* EKS Cluster Node EC2 Instance type */
#Use: var.instance_type["source"]
variable "instance_type" {
  type = map(string)
  default = {
    "dev_env"                = "t3.medium",
    "qa_env"                 = "t3.small",
    "prod_mem_optimized_env" = "m5.large",
    "prod_cpu_optimized_env" = "c5.large",
  }
}

###
## FIN de variables para eks
#########

##
## COMIENZO de variables para ec2 
##
variable "ec2_sg" {
  type    = string
  default = "ec2_woker_sg"

}

##AWS Region
#Use: var.aws_region["source"]
variable "aws_region" {
  type = map(string)
  default = {
    "source"      = "us-east-1",
    "destination" = "us-west-2"
  }
}

# TGW ID 
variable "tgw_id" {
  type    = string
  default = "tgw-048609c6fa8097f5c"
}

variable "vpc_id" {
  type    = string
  default = ""
}
# VPC  cidr block
variable "vpc_cidr" {
  type    = string
  default = "10.48.0.0/16"
}



/* SSH Key-Pair */

#Bastion Key
variable "bastion_key" {
  type    = string
  default = "Bastion-Key"
}

#EKS Nodes Key
variable "eks_nodes_key" {
  type    = string
  default = "EKS-Nodes-Key"
}

/* EKS Variable */

variable "cluster_name" {
  default = "demo-eks-cluster"
}

#Use: instance_type = var.cluster_version["version1"]
variable "cluster_version" {
  description = "Kubernetes version supported by EKS. Ref: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html"
  type        = map(string)
  default = {
    "latest_version"   = "1.22",
    "lts_version"      = "1.21",
    "previous_version" = "1.19.2",
    "oldest_supported" = "1.18.8"
  }
}


variable "cluster_log_type" {
  description = "Amazon EKS control plane logging Ref: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html"
  type        = list(string)
  default = [
    "api",
    "audit",
    "authenticator",
    "scheduler",
    "controllerManager"
  ]
}

variable "cluster_log_retention_days" {
  default = "90"
}


### Tags Variables ###
#Use: tags = merge(var.project-tags, { Name = "${var.resource-name-tag}-place-holder" }, )
variable "project-tags" {
  type = map(string)
  default = {
    service     = "SII-DRP",
    environment = "POC"
    owner       = "example@mail.com"
  }
}

variable "resource-name-tag" {
  type    = string
  default = "SII-DRP"
}