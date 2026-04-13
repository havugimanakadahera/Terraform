data "azurerm_key_vault" "existing" {
  name                = var.name
  resource_group_name = var.resource_group_name
}

locals {
  discovered_key_vault_id = data.azurerm_key_vault.existing.id
}

check "existing_key_vault_attributes" {
  assert {
    condition     = lower(data.azurerm_key_vault.existing.location) == lower(var.location)
    error_message = "Discovered Key Vault location does not match var.location for this environment."
  }

  assert {
    condition     = data.azurerm_key_vault.existing.tenant_id == data.azurerm_client_config.current.tenant_id
    error_message = "Discovered Key Vault tenant_id does not match current authenticated tenant."
  }
}
