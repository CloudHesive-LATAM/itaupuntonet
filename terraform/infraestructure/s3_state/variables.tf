variable "bucket_state_name" {
  type = string
  default = "itaunetinfrasandbox"
}

variable "aws_region" {
  type        = string
  description = "The AWS region where the terraform stack is created"
  default     = "us-east-1"
}

variable "dynamodb_table_name" {
  type        = string
  description = "The name of the DynamoDb table used to lock the state."
  default     = "terraform-locks-itau-puntonet"
}

variable "bucket_region" {
  type        = string
  description = "Region of S3 Bucket holding TF State"
  default     = "us-east-1"
}
