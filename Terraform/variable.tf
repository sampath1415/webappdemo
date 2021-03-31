variable "vnet_address_prefix" {
    default= ["10.0.0./16"]
    }

variable "subnet_address_prefix"{
    type=list(string)
    default= ["10.0.1.0/24"]
    }
  
  
