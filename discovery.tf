# Root-level discovery used by the import block.
# This ensures the import ID is resolved directly in the root module during plan.

data "azurerm_key_vault" "existing" {
  name                = var.name
  resource_group_name = var.resource_group_name

  lifecycle {
    postcondition {
      condition = replace(lower(trimspace(self.location)), " ", "") == replace(lower(trimspace(var.location)), " ", "")
      error_message = "Discovered Key Vault location does not match expected location"
    }

    postcondition {
      condition     = self.tenant_id == data.azurerm_client_config.current.tenant_id
      error_message = "Discovered Key Vault tenant_id does not match authenticated tenant"
    }
  }
}

locals {
  discovered_keyvault_id = data.azurerm_key_vault.existing.id
}
