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

inputs = merge(
  local.env_cfg.inputs,
  {
    name            = "${local.company}-${local.project}-${local.country}-${local.environment}-vpc"
    cidr            = local.country_cfg.locals.cidr
    azs             = local.country_cfg.locals.azs
    private_subnets = local.country_cfg.locals.private_subnets
    public_subnets  = local.country_cfg.locals.public_subnets

    tags = merge(
      local.env_cfg.locals.common_tags,
      {
        Project = local.project
        Country = local.country
      }
    )
  }
)
