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
  default     = "m5.large" 
}

variable "name" {
  type        = string
  description = "Name of the database"
  default     = "itaupuntonet" 
}

variable "secret_name" {
  type = string
  default = "itaunetsecretsandbox"
}

variable "username" {
  type = string
  default = "dbadmin"
}