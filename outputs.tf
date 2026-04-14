output "keyvault_import_address" {
  description = "Terraform resource address used for import"
  value       = "module.keyvault.azurerm_key_vault.this"
}

output "discovered_keyvault_id" {
  description = "Existing Azure Key Vault resource ID"
  value       = module.keyvault.discovered_id
}
