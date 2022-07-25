

# [STEP 1] - Base policy to be shared between ROLES
# At least DescribeCluster is going to be needed to update KubeConfig 
# 3.1 - Create Policy
resource "aws_iam_policy" "eks-get-kubeconfig-policy" {
  name   = "eks-get-kubeconfig-policy"  
  path   = "/"
  #policy = data.aws_iam_policy_document.read_policy_document.json
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster"
            ],
            "Resource": "*"
        }
        ]
    })
} 

data "aws_iam_policy_document" "shared-sts-policy" {
  
  statement {
    effect  = var.eks_master_IAM_policy_parameters["effect"]  # Allow
    actions = var.eks_master_IAM_policy_parameters["actions"] # sts assume role

    principals {
      type        = var.eks_master_IAM_policy_parameters["type"]        # Service
      identifiers = var.eks_master_IAM_policy_parameters["identifiers"] # who can assume it

    }

  }
}

# 3.2 Define STS policy Document (later is going to be used)

# ---------------------- ADMIN GROUP DEFINITION------------------------------


# 3.2 - Role
# Then create role
resource "aws_iam_role" "eks-admin-role" {
  
  name = "eks-admin-tf-role"
  # Like a trick, attach user defined policy first
  assume_role_policy  = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": ["arn:aws:iam::${var.cicd_account}:role/${var.cicd_role}", "arn:aws:iam::${var.destination_account}:root"]
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
  
  policy_arn = aws_iam_policy.eks-get-kubeconfig-policy.arn
  role       = aws_iam_role.eks-admin-role.name

}

# ---------------------- END: ADMIN GROUP DEFINITION------------------------------

# ---------------------- READER/DEPLOYER GROUP DEFINITION ------------------------------

# 3.4 - in "Pipeline Builder, add ClusterRole and ClusterRoleBinding based on"
# LVL 2 - DEPLOYER 
# LVL 3 - READER



# [STEP 3] - Create reader group (Level 2 , Level 3 - AWS resources) 
# 3.1 - Policy
/* resource "aws_iam_policy" "eks-non-admin-policy2" {
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
} */

# 3.2 - Role
# Then create role
resource "aws_iam_role" "eks-deployer-role" {
  
  name = "eks-deployer-tf-role"
  # Like a trick, attach user defined policy first
  assume_role_policy  = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": ["arn:aws:iam::793764525616:root", "arn:aws:iam::308582334619:root"]
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach1" {
  # Policies are defined as a list! it is needed to be converted to a SET.
  # Once defined, we have to iterate over it 
  
  policy_arn = aws_iam_policy.eks-get-kubeconfig-policy.arn
  role       = aws_iam_role.eks-deployer-role.name

}

resource "aws_iam_role" "eks-reader-role" {
  
  name = "eks-reader-tf-role"
  # Like a trick, attach user defined policy first
  assume_role_policy  = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": ["arn:aws:iam::793764525616:root", "arn:aws:iam::308582334619:root"]
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach2" {
  # Policies are defined as a list! it is needed to be converted to a SET.
  # Once defined, we have to iterate over it 
  
  policy_arn = aws_iam_policy.eks-get-kubeconfig-policy.arn
  role       = aws_iam_role.eks-reader-role.name

}

# 3.3 - Role Attachment (Role - Policy)
# then attach the role
/* resource "aws_iam_role_policy_attachment" "attach-non-admin-policy-to-non-admin-role" {
  # Policies are defined as a list! it is needed to be converted to a SET.
  # Once defined, we have to iterate over it 
  
  policy_arn = aws_iam_policy.eks-non-admin-policy2.arn
  role       = aws_iam_role.eks-non-admin-role.name

} */

# ---------------------- READER/DEPLOYER GROUP DEFINITION ------------------------------

# 3.4 - in "Pipeline Builder, add ClusterRole and ClusterRoleBinding based on"
# LVL 1 - ADMIN -> Mapped to EKS-ADMIN-ROLE
# -----------------------------------------------

# LVL 2 - DEPLOYER -> Mapped to EKS-NON-ADMIN-ROLE
# LVL 3 - READER -> Mapped to EKS-NON-ADMIN-ROLE
