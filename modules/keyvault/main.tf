resource "azurerm_key_vault" "this" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  soft_delete_retention_days  = var.soft_delete_retention_days

  sku_name = "standard"
  tags     = var.tags

  lifecycle {
    prevent_destroy = true
  }
}
