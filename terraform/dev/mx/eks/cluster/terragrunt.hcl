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
    eks_cluster_name    = "${local.company}-${local.project}-${local.country}-${local.environment}"
    eks_cluster_version = "1.31"
    eks_enable_irsa     = true

    create_admin_role       = true
    create_readonly_role    = true
    admin_role_requires_mfa = true

    trusted_role_arns = []

    custom_admin_role_policy_arns = [
      "arn:aws:iam::aws:policy/AdministratorAccess"
    ]

    custom_readonly_role_policy_arns = [
      "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ]

    eks_cluster_endpoint_public_access       = true
    eks_cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

    eks_vpc_id     = dependency.networking_vpc.outputs.vpc_id
    eks_subnet_ids = dependency.networking_vpc.outputs.private_subnets

    eks_managed_node_groups = {
      system = {
        name           = "system"
        instance_types = ["t3.medium"]
        min_size       = 1
        max_size       = 3
        desired_size   = 2
      }
      apps = {
        name           = "apps"
        instance_types = ["t3.large"]
        min_size       = 1
        max_size       = 4
        desired_size   = 2
      }
    }

    node_sg_rule_ingress_self_all_protocol  = "-1"
    node_sg_rule_ingress_self_all_from_port = 0
    node_sg_rule_ingress_self_all_to_port   = 0
    node_sg_rule_ingress_self_all_type      = "ingress"
    node_sg_rule_ingress_self_all_self      = true

    app_port                     = 8080
    app_source_security_group_id = ""
    enable_alb_http              = true

    aws_load_balancer_controller_namespace            = "kube-system"
    aws_load_balancer_controller_service_account_name = "aws-load-balancer-controller"

    eks_access_entry_admin_policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    eks_access_entry_view_policy_arn  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

    tags = merge(
      local.env_cfg.locals.common_tags,
      {
        Project = local.project
        Country = local.country
      }
    )
  }
)
