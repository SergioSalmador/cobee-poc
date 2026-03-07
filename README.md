# Go Webapp Platform - Implementation Summary

This repository contains the platform setup for `go-webapp` on AWS.
It includes Kubernetes, GitOps, and Terraform infrastructure for two environments and two countries.

## Scope
- Kubernetes app deployment with Helm.
- Argo CD applications per environment and country.
- AWS infrastructure with Terraform/Terragrunt:
  - VPC networking
  - EKS cluster
  - IRSA role for app
  - RDS PostgreSQL Multi-AZ

## Folder Overview

```text
k8s/
  go-webapp/              # Helm chart
  argocd/                 # Argo CD applications

terraform/
  dev|prod/
    es|mx/
      networking/vpc/
      eks/cluster/
      eks/iam-roles-app/
      rds/go-webapp/
```

## Architecture Sketch

```text
Users
  |
  v
AWS ALB Ingress
  |
  v
EKS (go-webapp)
  |-- Deployment / Service / HPA / PDB
  |-- ServiceAccount with IRSA
  |
  +--> External Secrets --> AWS Secrets Manager
                                ^
                                |
                           RDS PostgreSQL (Multi-AZ)
```

## Delivery Notes
- Docker and Kubernetes base setup was prepared for a lightweight app image and non-root runtime.
- Helm chart was organized under `k8s/go-webapp` with templates and values.
- Argo CD structure was created by environment and country.
- Terraform/Terragrunt structure was created with global, environment, and country settings.
- RDS uses PostgreSQL in Multi-AZ and private subnets.
- Secret strategy is based on RDS-managed password + IRSA + External Secrets.

## Important Inputs to Set Before Apply
- Real security group IDs in each `rds-common.hcl` (`eks_node_security_group_ids`).
- Real domain/certificate details for ALB ingress values.
- Real secret references in External Secrets values if names differ.

## Suggested Apply Order
1. `networking/vpc`
2. `eks/cluster`
3. `rds/go-webapp`
4. `eks/iam-roles-app`
5. Argo CD sync for app resources


## Diagrams (Image Files)
- [Architecture Overview](./diagrams/architecture-overview.svg)
- [Secret Flow](./diagrams/secret-flow.svg)
- [Latency Budget](./diagrams/latency-budget.svg)
