variable "eks_non_admin_IAM_policy_definition" {
  type = object({
    name        = string
    effect      = string
    actions     = list(string)
    
    identifiers = list(string)
  })

   default = {
    name        = "EKS-Non-Admin-Policy"
    effect      = "Allow"
    actions     = ["eks:*"]
    identifiers = ["*"]

  }
}


variable "destination_account" {
    type = string
    description = "destination account to be used as parameter"
    default = "793764525616"
}
variable "eks_non_admin_IAM_STS_policy" {
  default = {
    name        = "EKS-Non-Admin-STS-policy"
    effect      = "Allow"
    actions     = ["sts:AssumeRole"]
    type        = "AWS"
    
    
  }
  type = object({
    name        = string
    effect      = string
    actions     = list(string)
    type        = string
    
    
  })
}