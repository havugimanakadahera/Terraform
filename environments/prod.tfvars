environment         = "prod"
name                = "replace-with-prod-keyvault-name"
resource_group_name = "replace-with-prod-rg"
location            = "westeurope"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "prod"
  managed_by  = "terraform"
}
