output "vpc_id" {
  value = aws_vpc.virtual_private_cloud.id
}

output "public_security_group_id" {
  value = aws_security_group.allow_public_ssh.id
}

output "private_security_group_id" {
  value = aws_security_group.allow_private_ssh.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "vpc-arn" {
  value = aws_vpc.virtual_private_cloud.arn
}