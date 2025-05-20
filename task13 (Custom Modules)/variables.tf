
#Настройки для сети

variable "vpc_name" {
  default = "asad-vpc"
}

variable "vpc_count" {
  default = 2
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "public_cidr" {
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "private_cidr" {
  default     = ["10.0.11.0/24", "10.0.21.0/24"]
}

variable "database_cidr" {
  default     = ["10.0.12.0/24", "10.0.22.0/24"]
}

variable "vpc_tags" {
  default = {
    Name = "asad-terraform"
  }
}

////////////////////


#Настройки серверов

variable "amazon_linux" {
  default = "ami-00f34bf9aeacdf007"
}

variable "ubuntu_linux" {
  default = "ami-0c1ac8a41498c1a9c"
}

variable "bastion_name" {
  default = "jump-server"
}

variable "private_name" {
  default = "private-server"
}

////////////////////

