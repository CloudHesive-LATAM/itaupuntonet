# [STEP 1] - Use data TO OBTAIN TOKEN 
data "aws_eks_cluster_auth" "cluster_auth" {
  

  name = aws_eks_cluster.eks-cluster.name
}

# [STEP 2] - Generate Outputs 
output "eks_endpoint" {
  
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "eks_name" {
  
  value = aws_eks_cluster.eks-cluster.name
}

output "kubeconfig-certificate-authority-data" {
  
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

output "eks_token" {
  
  value = data.aws_eks_cluster_auth.cluster_auth.token
}




