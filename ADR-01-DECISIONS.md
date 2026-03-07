# ADR-01: Global Architecture Decisions

Date: 2026-03-07
Status: Accepted

## Context
We need a cloud-native platform for one app in two countries (ES, MX) and two environments (dev, prod).
The platform must be secure, easy to manage, and ready to scale.

## Decision 1: Kubernetes on AWS EKS
We use Amazon EKS for app runtime.

Why:
- Managed control plane.
- Good integration with AWS services.
- Easy scaling with node groups and HPA.

## Decision 2: Helm for app packaging
We deploy the app with a Helm chart (`k8s/go-webapp`).

Why:
- One reusable template.
- Easy per-environment values.
- Better version control for Kubernetes resources.

## Decision 3: Argo CD for GitOps
We use Argo CD with separate Applications for each env/country.

Why:
- Git is the source of truth.
- Clear separation by environment and country.
- Safe and repeatable sync process.

## Decision 4: Terraform + Terragrunt for infra
We use Terraform modules and Terragrunt hierarchy.

Why:
- Reuse and consistency.
- Global variables at environment/country level.
- Clear folder structure and simple automation.

## Decision 5: RDS PostgreSQL Multi-AZ
We use Amazon RDS PostgreSQL in private subnets and Multi-AZ mode.

Why:
- Managed database operations.
- Better availability.
- No public exposure.

## Decision 6: IRSA for app access to AWS
We use IAM Roles for Service Accounts.

Why:
- No static AWS credentials in pods.
- Fine-grained permission model.
- Better security and auditability.

## High-Level Architecture Sketch

```text
Internet
  |
AWS ALB Ingress Controller
  |
ALB
  |
EKS (namespace: go-webapp)
  |-- Deployment (replicas)
  |-- Service
  |-- HPA
  |-- PDB
  |-- ServiceAccount (IRSA)
  |
  +--> External Secrets --> AWS Secrets Manager

EKS private network --> RDS PostgreSQL (Multi-AZ, private)
```
