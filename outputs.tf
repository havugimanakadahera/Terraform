output "imported_key_vault_id" {
  description = "Resolved existing Key Vault ID used during import."
  value       = local.discovered_key_vault_id
}

output "discovered_key_vault_location" {
  description = "Location returned by Azure for the discovered Key Vault."
  value       = data.azurerm_key_vault.existing.location
}

output "expected_key_vault_location" {
  description = "Location provided through Terraform variables."
  value       = var.location
}

output "discovered_key_vault_tenant_id" {
  description = "Tenant ID returned by Azure for the discovered Key Vault."
  value       = data.azurerm_key_vault.existing.tenant_id
}

output "expected_tenant_id" {
  description = "Tenant ID from the authenticated Azure client context."
  value       = data.azurerm_client_config.current.tenant_id
}
