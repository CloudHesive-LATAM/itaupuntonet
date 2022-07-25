#Elastic for redis  Nodes type
#Use: var.nodes_type["source"]
variable "nodes_type" {
  type = map(string)
  default = {
    "dev_env"  = "cache.t3.small",
    "qa_env"   = "cache.t2.micro",
    "prod_env" = "cache.t3.small"
  }
}
#name Elastic For redis
variable "name_redis" {
  type    = string
  default = "redis-webapp"

}

##AWS Region
#Use: var.aws_region["source"]
variable "az" {
  type = map(string)
  default = {
    "az-a" = "us-east-1a",
    "az-b" = "us-east-1b"
  }
}


variable "parameter_group" {
  default = "default.redis6.x"
}

variable "desired_clusters" {
  default = "2"
}

variable "instance_type" {
  default = "cache.t2.micro"
}

variable "engine_version" {
  default = "6.2"
}

variable "automatic_failover_enabled" {
  default = true
}
