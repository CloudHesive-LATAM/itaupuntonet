# ------------------------
# IAM-NON-ROOT-SECTION
# ------------------------ 
# Finalmente nos tendrían que quedar 3 niveles
# Nivel 1: Admin, el creo el clúster -> done por defecto
# Nivel 2: Deployer, que hay que generar para los pipelines que despliegan apps
# Nivel 3: Reader, para un determinado perfil en pipeline

# 
# [STEP 1] - Create the policy is going to be attached to the role 


## FOR That is necessary build the document policy
## after, create the related policy
/* data "aws_iam_policy_document" "eks_non_admin_eks_iam_policy_document" {
  # create the "json" STS policy starting with statement 
  #(statement objects >=1)
  statement {
    effect  = var.eks_non_admin_IAM_policy_definition["effect"]  # Allow
    actions = var.eks_non_admin_IAM_policy_definition["actions"] # eks *
    resources = var.eks_non_admin_IAM_policy_definition["identifiers"]
  }
}

resource "aws_iam_policy" "eks_non_admin_eks_iam_policy" {
  name   = var.eks_non_admin_IAM_policy_definition["name"]  
  path   = "/"
  policy = data.aws_iam_policy_document.eks_non_admin_eks_iam_policy_document.json
}

# [STEP 2] - Create the STS Document policy (to be used in the role is going to be created) 

data "aws_iam_policy_document" "non_root_assume_role_policy_document" {
  # create the "json" policy starting with statement 
  #(statement objects >=1)
  statement {
    effect  = var.eks_non_admin_IAM_STS_policy["effect"]  # Allow
    actions = var.eks_non_admin_IAM_STS_policy["actions"] # sts assume role

    principals {
      type        = var.eks_non_admin_IAM_STS_policy["type"]        # Service
      identifiers = ["arn:aws:iam::${var.destination_account}:root"] # who can assume it

    }

  }
}

# [STEP 3] - Create the role and name it / Add the STS policy
resource "aws_iam_role" "eks_non_root_role" {
  depends_on = [
    data.aws_iam_policy_document.non_root_assume_role_policy_document
  ]
  name = "non-root-eks-role-dev"
  # Like a trick, attach user defined policy first
  assume_role_policy = data.aws_iam_policy_document.non_root_assume_role_policy_document.json

}

# [STEP 4] - Attach "User-created" NON ROOT EKS policy to the role 
resource "aws_iam_role_policy_attachment" "attach_non_root_policy_to_eks_role" {
  # Policies are defined as a list! it is needed to be converted to a SET.
  # Once defined, we have to iterate over it 
  depends_on = [
    aws_iam_role.eks_non_root_role, 
    aws_iam_policy.eks_non_admin_eks_iam_policy
    
  ]
  
  policy_arn = aws_iam_policy.eks_non_admin_eks_iam_policy.arn
  role       = aws_iam_role.eks_non_root_role.name

} */

# READER GROUP

# First policy document

/* data "aws_iam_policy_document" "read_policy_document" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "eks:DescribeNodegroup",
      "eks:ListNodegroups",
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:AccessKubernetesApi",
      "ssm:GetParameter",
      "eks:ListUpdates",
      "eks:ListFargateProfiles",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:PassRole"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["eks.amazonaws.com"]
    }
  }
} */

# ---------------------- ADMIN GROUP DEFINITION------------------------------

# [STEP 1] - Create ADMIN group (Level 1 - AWS resources) 
# 3.1 - Policy
resource "aws_iam_policy" "eks-admin-policy" {
  name   = "eks-admin-policy"  
  path   = "/"
  #policy = data.aws_iam_policy_document.read_policy_document.json
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
        ]
    })
}

# 3.2 - Role
# Then create role
resource "aws_iam_role" "eks-admin-role" {
  
  name = "eks-admin-role"
  # Like a trick, attach user defined policy first
  assume_role_policy  = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::793764525616:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
            }
        ]
    })
}

# 3.3 - Role Attachment (Role - Policy)
# then attach the role
resource "aws_iam_role_policy_attachment" "attach-admin-policy-to-admin-role" {
  # Policies are defined as a list! it is needed to be converted to a SET.
  # Once defined, we have to iterate over it 
  
  policy_arn = aws_iam_policy.eks-admin-policy.arn
  role       = aws_iam_role.eks-admin-role.name

}

# ---------------------- END: ADMIN GROUP DEFINITION------------------------------

# ---------------------- READER/DEPLOYER GROUP DEFINITION ------------------------------

# 3.4 - in "Pipeline Builder, add ClusterRole and ClusterRoleBinding based on"
# LVL 2 - DEPLOYER 
# LVL 3 - READER



# [STEP 3] - Create reader group (Level 2 , Level 3 - AWS resources) 
# 3.1 - Policy
resource "aws_iam_policy" "eks-non-admin-policy2" {
  name   = "eks-non-admin-policy2"  
  path   = "/"
  #policy = data.aws_iam_policy_document.read_policy_document.json
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Action": [
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:AccessKubernetesApi",
                "ssm:GetParameter",
                "eks:ListUpdates",
                "eks:ListFargateProfiles"
            ],
            "Resource": "*"
        }
        ]
    })
}

# 3.2 - Role
# Then create role
resource "aws_iam_role" "eks-non-admin-role" {
  
  name = "eks-non-admin-role"
  # Like a trick, attach user defined policy first
  assume_role_policy  = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::793764525616:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
            }
        ]
    })
}

# 3.3 - Role Attachment (Role - Policy)
# then attach the role
resource "aws_iam_role_policy_attachment" "attach-non-admin-policy-to-non-admin-role" {
  # Policies are defined as a list! it is needed to be converted to a SET.
  # Once defined, we have to iterate over it 
  
  policy_arn = aws_iam_policy.eks-non-admin-policy2.arn
  role       = aws_iam_role.eks-non-admin-role.name

}

# ---------------------- READER/DEPLOYER GROUP DEFINITION ------------------------------

# 3.4 - in "Pipeline Builder, add ClusterRole and ClusterRoleBinding based on"
# LVL 1 - ADMIN -> Mapped to EKS-ADMIN-ROLE
# -----------------------------------------------

# LVL 2 - DEPLOYER -> Mapped to EKS-NON-ADMIN-ROLE
# LVL 3 - READER -> Mapped to EKS-NON-ADMIN-ROLE
