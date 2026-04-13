output "resource_id" {
  description = "Resolved existing Key Vault ID used during import."
  value       = local.discovered_key_vault_id
}

output "discovered_location" {
  description = "Location returned by Azure for the discovered Key Vault."
  value       = data.azurerm_key_vault.existing.location
}

output "expected_location" {
  description = "Location provided through Terraform variables."
  value       = var.location
}

output "discovered_tenant_id" {
  description = "Tenant ID returned by Azure for the discovered Key Vault."
  value       = data.azurerm_key_vault.existing.tenant_id
}

output "expected_tenant_id" {
  description = "Tenant ID from root input."
  value       = var.tenant_id
}
