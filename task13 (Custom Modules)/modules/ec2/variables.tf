variable "free_tier_size" {
  default = ""
}

variable "amazon_linux" {
  default = ""
}

variable "ubuntu_linux" {
  default = ""
}

variable "bastion_name" {
  default = {}
}

variable "private_name" {
  default = {}
}

variable "key_name" {
  default = ""
}

variable "public_security_group_ids" {
  default = []
}

variable "private_security_group_ids" {
  default = []
}

variable "public_subnet_ids" {
  default = ""
}

variable "private_subnet_ids" {
  default = ""
}