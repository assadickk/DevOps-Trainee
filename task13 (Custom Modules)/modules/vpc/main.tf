resource "aws_vpc" "virtual_private_cloud" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.virtual_private_cloud.id
  count                   = var.vpc_count
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = var.vpc_azs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = var.vpc_tags
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.virtual_private_cloud.id
  count                   = var.vpc_count
  cidr_block              = var.private_cidr[count.index]
  availability_zone       = var.vpc_azs[count.index]
  tags = var.vpc_tags
}

resource "aws_subnet" "db_subnets" {
  vpc_id = aws_vpc.virtual_private_cloud.id
  count                   = var.vpc_count
  cidr_block              = var.database_cidr[count.index]
  availability_zone       = var.vpc_azs[count.index]
  tags = var.vpc_tags
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = var.db_subnet_group_name
  subnet_ids = aws_subnet.db_subnets[*].id
  tags = var.vpc_tags
}

resource "aws_security_group" "allow_public_ssh" {
  name        = "Bastion-SSH-only"
  vpc_id      = aws_vpc.virtual_private_cloud.id
  tags = var.vpc_tags
}

resource "aws_security_group" "allow_private_ssh" {
  name        = "Private-SSH-only"
  vpc_id      = aws_vpc.virtual_private_cloud.id
  tags = var.vpc_tags
}

resource "aws_vpc_security_group_ingress_rule" "ssh_public_ingress" {
  security_group_id = aws_security_group.allow_public_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = var.vpc_tags
}

resource "aws_vpc_security_group_egress_rule" "public_allow_egress" {
  security_group_id = aws_security_group.allow_public_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = var.vpc_tags
}

resource "aws_vpc_security_group_ingress_rule" "ssh_private_ingress" {
  security_group_id = aws_security_group.allow_private_ssh.id
  cidr_ipv4         = aws_vpc.virtual_private_cloud.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = var.vpc_tags
}

resource "aws_vpc_security_group_egress_rule" "private_allow_egress" {
  security_group_id = aws_security_group.allow_private_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = var.vpc_tags
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.virtual_private_cloud.id
  tags = var.vpc_tags
}

resource "aws_eip" "elastic_ip_for_nat" {
  count  = var.vpc_count
  domain = "vpc"
  tags = var.vpc_tags
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.vpc_count
  allocation_id = aws_eip.elastic_ip_for_nat[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = var.vpc_tags
}

resource "aws_route_table" "private_routes" {
  count  = var.vpc_count
  vpc_id = aws_vpc.virtual_private_cloud.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = var.vpc_tags
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.virtual_private_cloud.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = var.vpc_tags
}

resource "aws_route_table_association" "public_route_assosiation" {
  count          = var.vpc_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route.id 
}

resource "aws_route_table_association" "private_assoc" {
  count          = var.vpc_count
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_routes[count.index].id
}