data "azurerm_key_vault" "existing" {
  name                = var.name
  resource_group_name = var.resource_group_name

  lifecycle {
    postcondition {
      condition = replace(lower(trimspace(self.location)), " ", "") == replace(lower(trimspace(var.location)), " ", "")
      error_message = "Discovered Key Vault location does not match expected location"
    }

    postcondition {
      condition     = self.tenant_id == var.tenant_id
      error_message = "Discovered Key Vault tenant_id does not match authenticated tenant"
    }
  }
}

locals {
  discovered_id = data.azurerm_key_vault.existing.id
}
