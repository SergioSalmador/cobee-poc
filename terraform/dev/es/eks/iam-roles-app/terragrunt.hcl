include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  company_cfg = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  env_cfg     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  country_cfg = read_terragrunt_config(find_in_parent_folders("country.hcl"))
  project_cfg = read_terragrunt_config("project.hcl")

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

dependency "eks_cluster" {
  config_path = "../cluster"

  mock_outputs = {
    eks_oidc_provider = "oidc.eks.eu-west-1.amazonaws.com/id/EXAMPLE"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "rds_go_webapp" {
  config_path = "../../rds/go-webapp"

  mock_outputs = {
    rds_master_user_secret_arn = "arn:aws:secretsmanager:eu-west-1:111111111111:secret:example"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = merge(
  local.env_cfg.inputs,
  {
    role_name = "${local.company}-go-webapp-${local.country}-${local.environment}"

    oidc_provider             = dependency.eks_cluster.outputs.eks_oidc_provider
    service_account_namespace = "go-webapp"
    service_account_name      = "go-webapp-sa"

    secret_arns = [dependency.rds_go_webapp.outputs.rds_master_user_secret_arn]

    tags = merge(
      local.env_cfg.locals.common_tags,
      {
        Project = local.project
        Country = local.country
      }
    )
  }
)
