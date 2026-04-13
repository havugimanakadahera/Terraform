environment         = "uat"
name                = "replace-with-uat-keyvault-name"
location            = "westeurope"
resource_group_name = "replace-with-uat-rg"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "uat"
  managed_by  = "terraform"
}
