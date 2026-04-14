environment         = "stg"
name                = "replace-with-stg-keyvault-name"
resource_group_name = "replace-with-stg-rg"
location            = "westeurope"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "stg"
  managed_by  = "terraform"
}
