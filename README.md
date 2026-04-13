# Terraform Azure Import (State Rebuild)

This folder is an implementation starter to rebuild Terraform state for existing Azure resources **without destroy/recreate**.

## What is implemented now

- Dynamic ID discovery for an existing Key Vault:
  - lookup by `name` and `resource_group_name`
  - consistency checks for `location` and `tenant_id`
- Terraform import blocks + apply flow
- Environment tfvars for: `int`, `qa`, `uat`, `stg`, `prod`, `mir`
- Azure DevOps pipeline template to:
  - create backend resources if missing
  - initialize per-environment remote state
  - run import apply
  - enforce a no-change post-import drift gate

## Files

- `main.tf`: Key Vault resource declaration
- `discovery.tf`: existing Key Vault dynamic discovery and validation checks
- `imports.tf`: import block
- `azure-pipelines.yml`: multi-environment stage runner
- `pipelines/templates/job-import.yml`: job template used by each environment stage

## Required Azure DevOps variable group (per env)

Create one variable group per environment named:

- `tf-int`
- `tf-qa`
- `tf-uat`
- `tf-stg`
- `tf-prod`
- `tf-mir`

Each group must include:

- `TFSTATE_RESOURCE_GROUP`
- `TFSTATE_LOCATION`
- `TFSTATE_STORAGE_ACCOUNT`
- `TFSTATE_CONTAINER`

## Environment inputs

Update each `environments/<env>.tfvars` with real values:

- `name`
- `location`
- `resource_group_name`

## How dynamic ID resolution works

The discovered ID is computed from:

- `name = var.name`
- `resource_group_name = var.resource_group_name`

Then validated against:

- `location = var.location`
- `tenant_id = data.azurerm_client_config.current.tenant_id`

## Extending to all existing resources

Repeat the same pattern per resource type:

1. Add resource block in Terraform.
2. Add matching data lookup for existing object by identifying variables.
3. Add import block targeting that resource address.
4. Keep post-import drift gate in pipeline.

For resource types that cannot be reliably located via Terraform data sources, add Azure CLI discovery in pipeline and pass resolved IDs as inputs.
