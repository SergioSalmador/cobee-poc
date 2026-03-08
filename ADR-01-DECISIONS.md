# ADR-01: Global Architecture Decisions

Date: 2026-03-07
Status: Accepted

## Context
We need a cloud-native platform for one app in two countries (ES, MX) and two environments (dev, prod).
The platform must be secure, easy to manage, and ready to scale.

## Decision 1: Multi-Region by Country
We deploy one stack for Spain and one stack for Mexico.

Why:
- Better latency for local users.
- Better operational isolation.
- Better control for data residency.

## Decision 2: Kubernetes on AWS EKS
We use Amazon EKS for app runtime.

Why:
- Managed control plane.
- Good integration with AWS services.
- Easy scaling with node groups and HPA.

## Decision 3: Helm for app packaging
We deploy the app with a Helm chart (`k8s/go-webapp`).

Why:
- One reusable template.
- Easy per-environment values.
- Better version control for Kubernetes resources.

## Decision 4: Argo CD for GitOps
We use Argo CD with separate Applications for each env/country.

Why:
- Git is the source of truth.
- Clear separation by environment and country.
- Safe and repeatable sync process.

## Decision 5: Terraform + Terragrunt for infra
We use Terraform modules and Terragrunt hierarchy.

Why:
- Reuse and consistency.
- Global variables at environment/country level.
- Clear folder structure and simple automation.

## Decision 6: RDS PostgreSQL Multi-AZ
We use Amazon RDS PostgreSQL in private subnets and Multi-AZ mode.

Why:
- Managed database operations.
- Better availability.
- No public exposure.

## Decision 7: IRSA for app access to AWS
We use IAM Roles for Service Accounts.

Why:
- No static AWS credentials in pods.
- Fine-grained permission model.
- Better security and auditability.

## Data Residency Note
Country split is used to keep each country data path in its regional setup.
This supports local policy requirements and lower risk of cross-country data movement.

## High-Level Architecture Diagram

<img src="./diagrams/architecture-overview.svg" alt="Architecture overview diagram" width="1200" />

## Networking Diagram (Spain + Mexico)

<img src="./diagrams/networking-es-mx.svg" alt="Networking diagram for Spain and Mexico" width="1400" />

## Related ADRs
- [ADR-02-LATENCY-STRATEGY.md](./ADR-02-LATENCY-STRATEGY.md)
- [ADR-03-SECRET-MANAGEMENT.md](./ADR-03-SECRET-MANAGEMENT.md)
