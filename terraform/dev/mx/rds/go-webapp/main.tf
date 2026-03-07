
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.1.0"

  identifier = var.db_identifier

  engine               = "postgres"
  engine_version       = var.db_engine_version
  family               = var.db_family
  major_engine_version = var.db_major_engine_version
  instance_class       = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  port     = var.db_port

  manage_master_user_password = true

  multi_az               = true
  publicly_accessible    = false
  create_db_subnet_group = true
  subnet_ids             = var.db_subnet_ids
  vpc_security_group_ids = [module.security_group.security_group_id]

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = merge(var.tags, {
    Name = var.db_identifier
  })
}
