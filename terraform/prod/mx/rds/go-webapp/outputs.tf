output "db_instance_id" {
  value = module.rds.db_instance_identifier
}

output "db_instance_arn" {
  value = module.rds.db_instance_arn
}

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "db_instance_address" {
  value = module.rds.db_instance_address
}

output "db_instance_port" {
  value = module.rds.db_instance_port
}

output "rds_security_group_id" {
  value = module.security_group.security_group_id
}

output "rds_master_user_secret_arn" {
  value = try(module.rds.db_instance_master_user_secret_arn, null)
}

output "rds_master_user_secret_name" {
  value = try(
    element(split(":secret:", module.rds.db_instance_master_user_secret_arn), 1),
    null
  )
}
