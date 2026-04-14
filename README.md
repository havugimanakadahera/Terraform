Terraform KeyVault Adoption Sample

Goal
- Re-adopt existing Azure Key Vault into Terraform management after state/code loss.
- Do not recreate the existing resource.

What this sample does
- Defines a reusable keyvault module.
- Discovers existing Key Vault by name + resource group.
- Validates tenant and location.
- Uses Azure DevOps pipeline to run terraform import only when state is missing.
- Then runs plan/apply with a no-destroy safety gate.

Important resource address
- module.keyvault.azurerm_key_vault.this

Required DevOps variable group values (per env)
- TFSTATE_RESOURCE_GROUP
- TFSTATE_LOCATION
- TFSTATE_STORAGE_ACCOUNT
- TFSTATE_CONTAINER

How to use
1. Update environments/<env>.tfvars placeholders with real values.
2. Set azure service connection in azure-pipelines.yml parameter.
3. Run pipeline for int first.
4. Confirm state contains module.keyvault.azurerm_key_vault.this.
5. Promote to qa, uat, stg, prod, mir.

