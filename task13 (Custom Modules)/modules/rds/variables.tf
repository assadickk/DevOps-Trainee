variable "allocated_storage" {
  default = 10
}

variable "storage_type" {
  default = "gp2"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "multi_az" {
  default = false
}

variable "private_security_group_ids" {
  default = []
}

variable "db_subnet_group_name" {
  default = ""
}

variable "engine" {
  default = ""
}

variable "username" {
  default = ""
}

variable "password" {
  default = ""
}