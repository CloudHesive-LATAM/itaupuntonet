#To manage permissions for your applications that you deploy in Kubernetes. 
# You can either attach policies to Kubernetes nodes directly. 
# In that case, every pod will get the same access to AWS resources. 
# Or you can create OpenID connect provider, which will allow granting 
#IAM permissions based on the service account used by the pod. 

# FIRST, obtain OIDC ISSUER
variable "oidc_sa_name" {
    type = string
    description = "sa to be used in kubernetes"
    default = "base_oidc_sa"
}

data "tls_certificate" "eks" {
  # GET OIDC
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
  
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

# THEN, BUILD POLICY and needed ROLE

# [STEP 1] - Create IAM POLICY STS Document
data "aws_iam_policy_document" "base_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:${var.oidc_sa_name}"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

# [STEP 2] - Create AWS IAM ROLE and attach STS policy 
resource "aws_iam_role" "oidc_role_base" {
  assume_role_policy = data.aws_iam_policy_document.base_oidc_assume_role_policy.json
  name               = "oidc_role_base"
}

# [STEP 3] - Create policies to be attached to IAM ROLE 
# In this case is only a base policy (could be more than 1)

resource "aws_iam_policy" "base_oidc_sa_policy" {
  name = "base_oidc_sa_policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

# [STEP 4] - Finally, attach policy/ies to the created IAM ROLE 
resource "aws_iam_role_policy_attachment" "base_policy_attach" {
  role       = aws_iam_role.oidc_role_base.name
  policy_arn = aws_iam_policy.base_oidc_sa_policy.arn
}

output "base_role_arn" {
  value = aws_iam_role.oidc_role_base.arn
}