variable "environment" {
  description = "Environment name: int, qa, uat, stg, prod, mir."
  type        = string
}

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

variable "import_existing" {
  description = "Enable import block for existing resources."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to managed resources."
  type        = map(string)
  default     = {}
}
