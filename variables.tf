variable "environment" {
  description = "Environment name: int, qa, uat, stg, prod, mir"
  type        = string
}

variable "name" {
  description = "Existing Key Vault name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the Key Vault"
  type        = string
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
