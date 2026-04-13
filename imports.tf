# ─────────────────────────────────────────────────────────
# State Import — ONE-TIME phase per environment
#
# Purpose : Re-attach existing Azure resources to state
#           without destroying or recreating them.
#
# Lifecycle:
#   Keep this file enabled only for first state rebuild run.
#   After import succeeds, remove or comment this block.
#
# How the ID is resolved:
#   module.keyvault reads the existing Azure Key Vault by name +
#   resource_group_name and returns its full resource ID via output.
# ─────────────────────────────────────────────────────────

import {
  to = module.keyvault.azurerm_key_vault.key_vault
  id = module.keyvault.resource_id
}
