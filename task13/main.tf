provider "aws" {
  region = eu-north-1
}

////////////////////

#Data sources

# data "aws_vpc" "terraform_vpc" {
#   filter {
#     name   = "tag:Name"
#     values = ["asad-terraform-vpc"]
#   }
# }

# data "aws_security_group" "bastion_sg" {
#   filter {
#     name   = "tag:Description"
#     values = ["SSH access to Bastion"]
#   }
# }

////////////////////

#VPC

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" 
  
  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = var.vpc_azs
  private_subnets  = var.vpc_private_subnets
  public_subnets   = var.vpc_public_subnets
  database_subnets = var.vpc_database_subnets

  create_igw             = true
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  create_private_nat_gateway_route  = true
  create_database_nat_gateway_route = false
  
  tags = var.vpc_tags
}

////////////////////

#Security Groups

module "bastion_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  
  name        = "SSH-only"
  description = "SSH access to Bastion"
  vpc_id      = module.vpc.id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "private_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "SSH-only"
  description = "SSH access in local"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = var.vpc_cidr
}

////////////////////

#EC2-instances

module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion-host"

  instance_type          = var.free_tier_size
  ami                    = var.amazon_linux
  key_name               = "asad_key"
  monitoring             = false
  vpc_security_group_ids = [module.bastion_ssh_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = var.ec2_tags
}

module "ec2_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "private-server"

  instance_type          = var.free_tier_size
  ami                    = var.ubuntu_linux
  key_name               = "asad_key"
  vpc_security_group_ids = [module.private_ssh_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[1]

  tags = var.ec2_tags
}

////////////////////

#RDS

module "RDS_multiAZ" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "asad-rds-instance"

  engine            = "postgres"
  instance_class    = "db.t2.micro"
  multi_az          = true

  db_name  = "test_db"
  username = "root"
  password = "root"
  port     = "5432"

  vpc_security_group_ids = [module.private_ssh_sg.security_group_id]
  subnet_ids             = [module.vpc.database_subnets[0]]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  
}