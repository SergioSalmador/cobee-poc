# ADR-03: Secret Management and Security

Date: 2026-03-07
Status: Accepted

## Context
The app needs DB credentials and other sensitive values.
We must avoid hardcoded secrets and keep a strong security model.

## Decision
Use AWS Secrets Manager + External Secrets + IRSA.

## How it works
1. RDS creates and manages the master password in Secrets Manager (`manage_master_user_password = true`).
2. Terraform exposes the secret ARN as output.
3. External Secrets in Kubernetes reads the secret from AWS.
4. The pod receives values as Kubernetes Secret/env vars.
5. Access is allowed only through an IRSA role for the app ServiceAccount.

## Security controls
- No static AWS keys in app containers.
- Least privilege IAM policy (read only required secrets).
- Secrets stay encrypted at rest in AWS.
- Access is auditable with AWS logs.

## IAM Access Model
Access to secrets is controlled through IAM Roles for Service Accounts (IRSA).

The application ServiceAccount is associated with a dedicated IAM role that allows:

- `secretsmanager:GetSecretValue`
- `secretsmanager:DescribeSecret`

Permissions are scoped to specific secret ARNs to enforce least privilege.

## Data Residency and Secrets
Secret access follows country/environment boundaries.
Each app stack reads only the secrets it needs in its own regional setup.

## Rotation model
- RDS-managed secret rotation can be enabled.
- App consumes latest values through External Secrets sync.

## Risks and mitigations
- Risk: wrong IAM permissions.
  Mitigation: explicit role and resource ARNs.
- Risk: secret name mismatch.
  Mitigation: use Terraform outputs and shared values.
- Risk: namespace/serviceAccount mismatch for IRSA.
  Mitigation: standard naming in Helm values.

## Secret Flow Diagram

<img src="./diagrams/secret-flow.svg" alt="Secret flow diagram" width="1200" />

## Related ADRs
- [ADR-01-DECISIONS.md](./ADR-01-DECISIONS.md)
- [ADR-02-LATENCY-STRATEGY.md](./ADR-02-LATENCY-STRATEGY.md)
