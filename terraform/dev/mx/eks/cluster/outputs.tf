output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "eks_oidc_provider" {
  value = module.eks.oidc_provider
}
