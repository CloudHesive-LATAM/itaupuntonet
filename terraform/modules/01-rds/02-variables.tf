# Database password - Secret Manager

variable "secret_name" {
  type = string
  default = "itaunetsecretsandbox4"
}


# RDS Instance

variable "allocated_storage" {
  type        = number
  description = "Total Storage"
  default     = "100" 
}

variable "engine_version" {
  type        = string
  description = "DB engine version"
  default     = "14.1" 
}

variable "engine" {
  type        = string
  description = "DB engine"
  default     = "postgres" 
}

variable "instance_class" {
  type        = string
  description = "Type of RDS Instance"
  default     = "db.t3.micro" 
}

variable "name" {
  type        = string
  description = "Name of the database"
  default     = "itaupuntonet" 
}

variable "username" {
  type = string
  default = "dbadmin"
}

variable "subnet_ids" {
  type = list(string)
}