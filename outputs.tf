output "keyvault_import_address" {
  description = "Terraform resource address used for import"
  value       = "module.keyvault.azurerm_key_vault.this"
}

output "discovered_keyvault_id" {
  description = "Existing Azure Key Vault resource ID"
  value       = local.discovered_keyvault_id
}

output "discovered_keyvault_name" {
  description = "Discovered Azure Key Vault name"
  value       = data.azurerm_key_vault.existing.name
}

output "discovered_keyvault_resource_group" {
  description = "Resource group returned by discovery"
  value       = data.azurerm_key_vault.existing.resource_group_name
}

output "discovered_keyvault_location" {
  description = "Location returned by discovery"
  value       = data.azurerm_key_vault.existing.location
}
