terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

////////////////// VPC //////////////////

module "vpc" {
  source = "./modules/vpc" 
  
  vpc_name                = var.vpc_name
  vpc_cidr                = var.vpc_cidr
  vpc_count               = var.vpc_count
  public_cidr             = var.public_cidr
  private_cidr            = var.private_cidr
  vpc_azs                 = var.vpc_azs
  database_cidr           = var.database_cidr
  db_subnet_group_name    = "asad-vpc-subnet-group"
  map_public_ip_on_launch = true
  vpc_tags                = var.vpc_tags
}

////////////////// EC-2 //////////////////

module "ec2" {
  source  = "./modules/ec2"

  key_name       = "asad_key"
  amazon_linux   = var.amazon_linux
  ubuntu_linux   = var.ubuntu_linux
  free_tier_size = "t3.micro"
  bastion_name   = var.bastion_name
  private_name   = var.private_name
  private_security_group_ids = [module.vpc.private_security_group_id]
  public_subnet_ids = module.vpc.public_subnet_ids[0]
}

////////////////// RDS //////////////////

module "rds" {
  source = "./modules/rds"

  db_subnet_group_name       = module.vpc.db_subnet_group_name
  private_security_group_ids = [module.vpc.private_security_group_id]
  allocated_storage          = 20  
  storage_type               = "gp2"
  instance_class             = "db.t3.micro"
  engine                     = "mysql"
  username                   = "root"
  password                   = "rootroot"
  multi_az                   = true
}