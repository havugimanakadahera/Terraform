import {
  for_each = var.import_existing ? toset(["key_vault"]) : toset([])
  to       = azurerm_key_vault.key_vault
  id       = local.discovered_key_vault_id
}
