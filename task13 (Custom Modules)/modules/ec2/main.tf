resource "aws_instance" "public_instance" {
  key_name               = var.key_name
  ami                    = var.amazon_linux
  instance_type          = var.free_tier_size
  subnet_id              = var.public_subnet_ids
  vpc_security_group_ids = var.public_security_group_ids

  tags = {
    Name = "${var.bastion_name}"
  }
}

resource "aws_instance" "private_instance" {
  ami                    = var.ubuntu_linux
  instance_type          = var.free_tier_size
  subnet_id              = var.private_subnet_ids
  vpc_security_group_ids = var.private_security_group_ids

  tags = {
    Name = "${var.private_name}"
  }
}