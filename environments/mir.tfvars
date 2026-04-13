environment         = "mir"
name                = "replace-with-mir-keyvault-name"
location            = "westeurope"
resource_group_name = "replace-with-mir-rg"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "mir"
  managed_by  = "terraform"
}
