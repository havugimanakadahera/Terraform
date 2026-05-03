variable "environment" {
  description = "Environment name: int, qa, uat, stg, prod, mir"
  type        = string
}

variable "name" {
  description = "Existing Key Vault name"
  type        = string

  validation {
    condition     = !can(regex("replace-with", var.name))
    error_message = "ERROR: 'name' contains placeholder text. Run: .\\scripts\\discover-keyvaults.ps1 to find real Key Vault names."
  }
}

variable "resource_group_name" {
  description = "Resource group containing the Key Vault"
  type        = string

  validation {
    condition     = !can(regex("replace-with", var.resource_group_name))
    error_message = "ERROR: 'resource_group_name' contains placeholder text. Run: .\\scripts\\discover-keyvaults.ps1 to find real resource group names."
  }
}

variable "location" {
  description = "Expected location"
  type        = string
}

variable "enabled_for_disk_encryption" {
  description = "Key Vault disk encryption flag"
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention days"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied by Terraform"
  type        = map(string)
  default     = {}
}
