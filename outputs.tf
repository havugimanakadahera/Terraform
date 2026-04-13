output "imported_key_vault_id" {
  description = "Resolved existing Key Vault ID used during import."
  value       = module.keyvault.resource_id
}

output "discovered_key_vault_location" {
  description = "Location returned by Azure for the discovered Key Vault."
  value       = module.keyvault.discovered_location
}

output "expected_key_vault_location" {
  description = "Location provided through Terraform variables."
  value       = module.keyvault.expected_location
}

output "discovered_key_vault_tenant_id" {
  description = "Tenant ID returned by Azure for the discovered Key Vault."
  value       = module.keyvault.discovered_tenant_id
}

output "expected_tenant_id" {
  description = "Tenant ID from the authenticated Azure client context."
  value       = module.keyvault.expected_tenant_id
}
