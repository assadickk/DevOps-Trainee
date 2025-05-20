resource "aws_db_instance" "related_database_service" {
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  instance_class    = var.instance_class

  vpc_security_group_ids = var.private_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  multi_az = var.multi_az
  engine = var.engine
  username = var.username
  password = var.password
  skip_final_snapshot = var.skip_final_snapshot
}