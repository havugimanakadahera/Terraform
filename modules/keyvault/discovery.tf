# ─────────────────────────────────────────────────────────
# Key Vault — Discovery
# Reads the EXISTING Azure Key Vault identified by name +
# resource_group_name and exposes its full resource ID.
# Also validates location and tenant against expected values
# so a wrong environment cannot be silently imported.
# ─────────────────────────────────────────────────────────

data "azurerm_key_vault" "existing" {
  name                = var.name
  resource_group_name = var.resource_group_name

  lifecycle {
    # postcondition runs after the data source is read, before any apply.
    # Unlike check blocks (root-only), postcondition works inside modules
    # and raises a hard ERROR — the pipeline will not proceed if it fails.

    postcondition {
      # Normalize both sides: "West Europe" and "westeurope" both become "westeurope"
      condition = (
        replace(lower(trimspace(self.location)), " ", "")
        ==
        replace(lower(trimspace(var.location)), " ", "")
      )
      error_message = "Discovered Key Vault location (${self.location}) does not match var.location (${var.location}). Check the environment tfvars."
    }

    postcondition {
      condition     = self.tenant_id == var.tenant_id
      error_message = "Discovered Key Vault tenant_id (${self.tenant_id}) does not match the authenticated tenant (${var.tenant_id}). Wrong subscription or environment?"
    }
  }
}

locals {
  discovered_key_vault_id = data.azurerm_key_vault.existing.id
}
