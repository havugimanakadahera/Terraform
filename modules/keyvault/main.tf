# ─────────────────────────────────────────────────────────
# Key Vault — Managed Resource
# Declares the Key Vault that Terraform manages after import.
# prevent_destroy ensures no accidental deletion cross-env.
# ─────────────────────────────────────────────────────────

resource "azurerm_key_vault" "key_vault" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days

  sku_name = "standard"
  tags     = var.tags

  lifecycle {
    prevent_destroy = true
  }
}
