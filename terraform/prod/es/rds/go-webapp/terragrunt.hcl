include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  company_cfg    = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  env_cfg        = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  country_cfg    = read_terragrunt_config(find_in_parent_folders("country.hcl"))
  project_cfg    = read_terragrunt_config("project.hcl")
  rds_common_cfg = read_terragrunt_config(find_in_parent_folders("rds-common.hcl"))

  postgres_cfg = local.rds_common_cfg.locals.db_engine_versions.postgres

  company     = local.company_cfg.locals.company
  project     = local.project_cfg.locals.project
  environment = local.env_cfg.locals.environment
  country     = local.country_cfg.locals.country
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF_PROVIDER
provider "aws" {
  region = "${local.country_cfg.locals.aws_region}"
}
EOF_PROVIDER
}

dependency "networking_vpc" {
  config_path = "../../networking/vpc"

  mock_outputs = {
    vpc_id          = "vpc-00000000000000000"
    private_subnets = ["subnet-00000000000000001", "subnet-00000000000000002", "subnet-00000000000000003"]
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = merge(
  local.env_cfg.inputs,
  {
    db_identifier = "${local.company}-${local.project}-${local.country}-${local.environment}"
    db_name       = "gowebapp"
    db_username   = "gowebapp_admin"
    db_port       = 5432

    db_engine_version       = local.postgres_cfg.engine_version
    db_family               = local.postgres_cfg.family
    db_major_engine_version = local.postgres_cfg.major_engine_version

    db_instance_class        = local.environment == "prod" ? "db.t4g.small" : "db.t4g.micro"
    db_allocated_storage     = local.environment == "prod" ? 50 : 20
    db_max_allocated_storage = local.environment == "prod" ? 200 : 100

    backup_retention_period = local.environment == "prod" ? 7 : 3
    backup_window           = "03:00-04:00"
    maintenance_window      = "Sun:04:00-Sun:05:00"

    deletion_protection = local.environment == "prod"
    skip_final_snapshot = local.environment != "prod"

    vpc_id                      = dependency.networking_vpc.outputs.vpc_id
    db_subnet_ids               = dependency.networking_vpc.outputs.private_subnets
    eks_node_security_group_ids = local.rds_common_cfg.locals.eks_node_security_group_ids

    tags = merge(
      local.env_cfg.locals.common_tags,
      {
        Project = local.project
        Country = local.country
      }
    )
  }
)
