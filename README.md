Terraform KeyVault Adoption Sample

Goal
- Re-adopt existing Azure Key Vault into Terraform management after state/code loss.
- Do not recreate the existing resource.

What this sample does
- Defines a reusable keyvault module.
- Discovers existing Key Vault by name + resource group.
- Validates tenant and location match.
- Uses code-driven import blocks (no terraform import CLI commands).
- Runs plan/apply with destroy safety gates.

Important resource address
- module.keyvault.azurerm_key_vault.this

Required DevOps variable group values (per env)
- TFSTATE_RESOURCE_GROUP
- TFSTATE_LOCATION
- TFSTATE_STORAGE_ACCOUNT
- TFSTATE_CONTAINER

Quick Start Guide
⚠️  **Required:** Read [scripts/IMPLEMENTATION_GUIDE.md](scripts/IMPLEMENTATION_GUIDE.md) for step-by-step instructions

Helper Scripts
1. **[discover-keyvaults.ps1](scripts/discover-keyvaults.ps1)**: List existing Key Vaults in your Azure subscription
   ```powershell
   .\scripts\discover-keyvaults.ps1
   ```

2. **[validate-tfvars.ps1](scripts/validate-tfvars.ps1)**: Pre-validate tfvars before running terraform
   ```powershell
   .\scripts\validate-tfvars.ps1 -Environment int
   ```

How to use
1. Run discover-keyvaults.ps1 to find existing Key Vault names
2. Update environments/<env>.tfvars with real values
3. Run validate-tfvars.ps1 to test configuration
4. Run terraform plan/apply for int first
5. Confirm state contains module.keyvault.azurerm_key_vault.this
6. Promote to qa, uat, stg, prod, mir environments

Troubleshooting
- Import showing "1 to add" instead of "1 to import"? → Check tfvars values are not placeholders
- Key Vault not found error? → Run discover-keyvaults.ps1 to verify name/resource group
- See scripts/IMPLEMENTATION_GUIDE.md for full troubleshooting section


