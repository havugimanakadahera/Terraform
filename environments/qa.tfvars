environment         = "qa"
name                = "replace-with-qa-keyvault-name"
resource_group_name = "replace-with-qa-rg"
location            = "westeurope"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "qa"
  managed_by  = "terraform"
}
