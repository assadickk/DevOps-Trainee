
#Настройки для сети

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "asad-terraform-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["eu-west-1", "eu-west-2"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "vpc_database_subnets" {
  description = "Database subnets for VPC"
  type        = list(string)
  default     = ["10.0.30.0/24", "10.0.31.0/24"]
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform = "true"
    Purpose   = "learning"
  }
}

////////////////////


#Настройки серверов

variable "free_tier_size" {
  description = "Type of ec2 instance"
  type        = string
  default     = "t2.micro"
}

variable "amazon_linux" {
  type    = string
  default = "ami-074e262099d145e90"
}

variable "ubuntu_linux" {
  type    = string
  default = "ami-0160e8d70ebc43ee1"
}

variable "ec2_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform = "true"
    Purpose   = "learning"
  }
}

////////////////////

