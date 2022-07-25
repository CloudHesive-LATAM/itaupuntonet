#Elastic for redis  Nodes type
#Use: var.nodes_type["source"]
  variable "nodes_type" {
    type = map(string)
    default = {
      "dev_env"                = "cache.t3.small",
      "qa_env"                 = "cache.t2.micro",
      "prod_env" = "cache.t3.small"
    }
  }
#name Elastic For redis
variable "name_redis" {
  type    = string
  default = "redis-webapp"

}

variable "cidr_block" {
  type        = list(string)
  description = "CIDR Block"
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC"
}

##AWS Region
#Use: var.aws_region["source"]
variable "az" {
  type = map(string)
  default = {
    "az-a"     = "us-east-1a",
    "az-b" = "us-east-1b"
  }
}
