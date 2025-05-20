output "bastion-server-arn" {
  value = aws_instance.public_instance.arn
}

output "private-server-arn" {
  value = aws_instance.private_instance.arn
}