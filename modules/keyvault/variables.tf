variable "name" {
  description = "Key Vault name."
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the Key Vault exists."
  type        = string
}

variable "enabled_for_disk_encryption" {
  description = "Matches existing Key Vault setting."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention for Key Vault."
  type        = number
  default     = 7
}

variable "tenant_id" {
  description = "Expected tenant id from current authenticated Azure client context."
  type        = string
}

variable "tags" {
  description = "Tags to apply to managed resources."
  type        = map(string)
  default     = {}
}
