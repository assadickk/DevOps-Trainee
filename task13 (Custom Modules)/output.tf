output "db-arn" {
  value = "database arn: ${module.rds.db-arn}"
}

output "bastion-arn" {
  value = "bastion arn: ${module.ec2.bastion-server-arn}"
}

output "private-arn" {
  value = "private arn: ${module.ec2.private-server-arn}"
}

output "vpc-arn" {
  value = "vpc arn: ${module.vpc.vpc-arn}"
}