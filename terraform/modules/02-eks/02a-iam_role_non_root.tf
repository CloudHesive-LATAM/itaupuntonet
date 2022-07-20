# ------------------------
# IAM-NON-ROOT-SECTION
# ------------------------ 
# [STEP 1] - Create the policy is going to be attached to the role 

## FOR That is necessary build the document policy
## after, create the related policy
data "aws_iam_policy_document" "eks_non_admin_eks_iam_policy_document" {
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

}

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

# then policy
resource "aws_iam_policy" "reader_policy" {
  name   = "reader_policy"  
  path   = "/"
  #policy = data.aws_iam_policy_document.read_policy_document.json
   policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
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
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}


# Then create role
resource "aws_iam_role" "reader_role" {
  
  name = "reader_role"
  # Like a trick, attach user defined policy first
  assume_role_policy = data.aws_iam_policy_document.non_root_assume_role_policy_document.json
  
}


# then attach the rle
resource "aws_iam_role_policy_attachment" "attach_reader_policy_to_eks_reader_role" {
  # Policies are defined as a list! it is needed to be converted to a SET.
  # Once defined, we have to iterate over it 
  
  
  policy_arn = aws_iam_policy.reader_policy.arn
  role       = aws_iam_role.reader_role.name

}


resource "aws_iam_user" "reader_user" {
  name = "reader_user"
  path = "/"

}

/* resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
} */

resource "aws_iam_user_policy" "reader_user_policy" {
  name = "reader_user_policy"
  user = aws_iam_user.reader_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "arn:aws:iam::${var.destination_account}:role/reader_role"
        }
    ]
}
EOF
}