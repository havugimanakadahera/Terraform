environment         = "int"
name                = "replace-with-int-keyvault-name"
resource_group_name = "replace-with-int-rg"
location            = "westeurope"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "int"
  managed_by  = "terraform"
}
