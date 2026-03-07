# Terragrunt Layout

This setup keeps global variables separated by environment and country, and deploys multi-AZ VPCs with public and private subnets.

Global variables hierarchy:

- `company` from `terraform/global.hcl`
- `environment` from `terraform/<env>/env.hcl`
- `country` from `terraform/<env>/<country>/country.hcl`
- `project` from `terraform/<env>/<country>/networking/vpc/project.hcl`

Convention used:

- `.tf` files define Terraform resources/modules (easy to inspect module code).
- `.hcl` files are used only for Terragrunt inheritance, provider generation, and remote state.

## Structure

- `terraform/global.hcl`
- `terraform/dev/es/networking/vpc`
- `terraform/dev/es/eks/cluster`
- `terraform/dev/mx/networking/vpc`
- `terraform/dev/mx/eks/cluster`
- `terraform/prod/es/networking/vpc`
- `terraform/prod/es/eks/cluster`
- `terraform/prod/mx/networking/vpc`
- `terraform/prod/mx/eks/cluster`

Each `.../networking/vpc` folder contains:

- `main.tf` (VPC module `terraform-aws-modules/vpc/aws` `6.6.0`)
- `variables.tf`
- `project.hcl` (local project name for this stack, e.g. `network`)
- `terragrunt.hcl` (inherits company/env/country/project vars and generates provider)

Each `.../eks/cluster` folder contains:

- `main.tf` (IAM roles + EKS module `terraform-aws-modules/eks/aws` `21.15.1`)
- `variables.tf`
- `project.hcl` (local project name for this stack, e.g. `eks`)
- `terragrunt.hcl` (depends on `../../networking/vpc` for VPC ID and private subnets)

EKS defaults include multiple managed node groups and private subnet placement across 3 AZs (from networking outputs).
It also includes IAM policy + IRSA role + security group resources for AWS Load Balancer Controller.

## Run examples

```bash
cd terraform/dev/es/networking/vpc
terragrunt init
terragrunt plan
terragrunt apply
```

Or run all VPCs in one environment:

```bash
cd terraform/dev
terragrunt run-all plan
```
