module "keyvault" {
  source = "./modules/keyvault"

  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  soft_delete_retention_days  = var.soft_delete_retention_days
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  tags                        = var.tags
}
