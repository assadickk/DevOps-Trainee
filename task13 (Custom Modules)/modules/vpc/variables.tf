variable "vpc_name" {
  default     = ""
}

variable "vpc_count" {
  default = 0
}

variable "vpc_cidr" {
  default     = ""
}

variable "vpc_azs" {
  default     = []
}

variable "private_cidr" {
  default     = []
}

variable "public_cidr" {
  default     = []
}

variable "database_cidr" {
  default     = []
}

variable "db_subnet_group_name" {
  default = ""
}

variable "vpc_tags" {
  default = {}
}

variable "map_public_ip_on_launch" {
  default = false
}