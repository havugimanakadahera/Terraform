environment         = "stg"
name                = "replace-with-stg-keyvault-name"
location            = "westeurope"
resource_group_name = "replace-with-stg-rg"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "stg"
  managed_by  = "terraform"
}
