# Security Checklist

Date: 2026-03-07
Status: Completed for current implementation baseline

## Identity and Access
- [x] IRSA model selected for app AWS access.
- [x] Dedicated IAM role for app service account.
- [x] IAM policy scope limited to needed secret reads.
- [x] No static AWS credentials in app manifests.

## Secrets
- [x] DB password is managed by AWS (RDS + Secrets Manager).
- [x] External Secrets pattern defined for injection to app.
- [x] Secret ARN output available from Terraform.

## Network
- [x] EKS and RDS in private subnets.
- [x] RDS is not public.
- [x] RDS SG allows PostgreSQL only from approved EKS SG IDs.
- [x] Ingress exposure through ALB controller.

## Kubernetes Workload Safety
- [x] Readiness probe configured.
- [x] Liveness probe configured.
- [x] PDB configured with minimum replicas logic.
- [x] HPA configured (CPU and memory).

## Platform Operations
- [x] GitOps with Argo CD.
- [x] Environment/country separation implemented.
- [x] Terraform/Terragrunt structure for repeatable infra.

## Remaining Actions (Recommended)
- [ ] Enable and validate secret rotation schedule.
- [ ] Add WAF in front of ALB for internet traffic.
- [ ] Add runtime security scanning (image + cluster).
- [ ] Add backup restore test for RDS.
