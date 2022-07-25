# [STEP 1] - Use data TO OBTAIN TOKEN 
data "aws_eks_cluster_auth" "cluster_auth" {

  name = aws_eks_cluster.eks-cluster.name
}


/* # # [STEP 2] - Store also in SSM
resource "aws_secretsmanager_secret" "eks-kubeconfig" {
  provider = aws.sts-shared-security
  name = "eks-kubeconfig"
}

resource "aws_secretsmanager_secret_version" "eks-kubeconfig-secret" {
  provider = aws.sts-shared-security
  secret_id     = aws_secretsmanager_secret.eks-kubeconfig.id
  secret_string = local_file.kubeconfig.sensitive_content
} */

resource "local_file" "kubeconfig" {
  sensitive_content = templatefile("${path.module}/scripts/kubeconfig.tpl", {
    cluster_name = aws_eks_cluster.eks-cluster.name,
    clusterca    = aws_eks_cluster.eks-cluster.certificate_authority[0].data,
    endpoint     = aws_eks_cluster.eks-cluster.endpoint,
    region       = "us-east-1"
  })
  filename = "${path.module}/scripts/kubeconfig-test"
}