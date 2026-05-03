environment         = "uat"

# ⚠️  REQUIRED: Fill these with real values from your Azure subscription
# Run: ..\ scripts\discover-keyvaults.ps1 to discover existing Key Vaults
# Then copy the Name and Resource Group from the output below
name                = "kv-uat-app"                   # Example: change to your actual Key Vault name
resource_group_name = "rg-uat-vault"                 # Example: change to your actual resource group

# Location must match your Key Vault's location in Azure
location            = "westeurope"                    # Verify this matches your Key Vault location

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "uat"
  managed_by  = "terraform"
}
