# ─────────────────────────────────────────────────────────
# State Import — ONE-TIME phase per environment
#
# Purpose : Re-attach existing Azure resources to state
#           without destroying or recreating them.
#
# Lifecycle:
#   First pipeline run  → set import_existing = true  (imports run)
#   All subsequent runs → set import_existing = false  (imports skipped)
#
# How the ID is resolved:
#   module.keyvault reads the existing Azure Key Vault by name +
#   resource_group_name and returns its full resource ID via output.
# ─────────────────────────────────────────────────────────

import {
  for_each = var.import_existing ? toset(["key_vault"]) : toset([])
  to       = module.keyvault.azurerm_key_vault.key_vault
  id       = module.keyvault.resource_id
}
