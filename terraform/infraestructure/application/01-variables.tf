variable "aws_region" {
  type        = string
  description = "The AWS region where the terraform stack is created"
  default     = "us-east-1"
}

variable "role_arn_sts_shared" {

  type = string
  default = "faf"

} 