#---------------------------
#Variable definition EFS
#---------------------------

#name for efs
variable "name-efs"{
  type = string
  default = "webapp"
}

#Name For KMS
variable "kms-name"{
  type = string
  default = "webapp"
}

# Encrypted false or true
variable "encrypted"{
  type = string
  default = true
}

# Perfomance Mode
#Use: var.performance_mode["source"]
variable "performance_mode"{
  type = map(string)
  default = {
    generalpurpose = "generalPurpose",
    maxIO = "maxIO"
  }
}

# throughput mode 
#Use: var.throughput_mode["source"]
variable "throughput_mode"{
  type = map(string)
  default = {
    bursting = "bursting",
    provisioned = "provisioned" #Cuando utilice provisioned, configure también provisioned_throughput_in_mibps
  }
}

variable "provisioned_throughput_in_mibps"{
  type = string
  default = "throughput_mode" #Solo aplicable con throughput_mode establecido en provisioned
}



