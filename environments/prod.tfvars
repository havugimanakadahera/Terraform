environment         = "prod"
name                = "replace-with-prod-keyvault-name"
location            = "westeurope"
resource_group_name = "replace-with-prod-rg"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "prod"
  managed_by  = "terraform"
}
