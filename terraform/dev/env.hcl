locals {
  company_cfg = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  environment = "dev"

  common_tags = {
    Company     = local.company_cfg.locals.company
    Environment = "dev"
    ManagedBy   = local.company_cfg.locals.managed_by
  }
}

inputs = {
  enable_nat_gateway = true
  single_nat_gateway = true
}
