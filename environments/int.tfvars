environment         = "int"
name                = "replace-with-int-keyvault-name"
location            = "westeurope"
resource_group_name = "replace-with-int-rg"

enabled_for_disk_encryption = true
soft_delete_retention_days  = 7

tags = {
  environment = "int"
  managed_by  = "terraform"
}
