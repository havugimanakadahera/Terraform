# Code-driven state adoption for existing Key Vault.
# During plan/apply, Terraform imports the discovered existing resource ID
# into this state address instead of trying to create a new resource.

import {
  to = module.keyvault.azurerm_key_vault.this
  id = module.keyvault.discovered_id
}
