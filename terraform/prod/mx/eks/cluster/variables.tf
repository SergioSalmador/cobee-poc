variable "eks_cluster_name" {
  type = string
}

variable "eks_cluster_version" {
  type = string
}

variable "eks_enable_irsa" {
  type = bool
}

variable "create_admin_role" {
  type = bool
}

variable "create_readonly_role" {
  type = bool
}

variable "admin_role_requires_mfa" {
  type = bool
}

variable "trusted_role_arns" {
  type = list(string)
}

variable "custom_admin_role_policy_arns" {
  type = list(string)
}

variable "custom_readonly_role_policy_arns" {
  type = list(string)
}

variable "eks_cluster_endpoint_public_access" {
  type = bool
}

variable "eks_cluster_endpoint_public_access_cidrs" {
  type = list(string)
}

variable "eks_vpc_id" {
  type = string
}

variable "eks_subnet_ids" {
  type = list(string)
}

variable "eks_managed_node_groups" {
  type = map(object({
    name           = string
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
  }))
}

variable "node_sg_rule_ingress_self_all_protocol" {
  type = string
}

variable "node_sg_rule_ingress_self_all_from_port" {
  type = number
}

variable "node_sg_rule_ingress_self_all_to_port" {
  type = number
}

variable "node_sg_rule_ingress_self_all_type" {
  type = string
}

variable "node_sg_rule_ingress_self_all_self" {
  type = bool
}

variable "app_port" {
  type = number
}

variable "app_source_security_group_id" {
  type = string
}

variable "enable_alb_http" {
  type = bool
}

variable "aws_load_balancer_controller_namespace" {
  type = string
}

variable "aws_load_balancer_controller_service_account_name" {
  type = string
}

variable "eks_access_entry_admin_policy_arn" {
  type = string
}

variable "eks_access_entry_view_policy_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}
