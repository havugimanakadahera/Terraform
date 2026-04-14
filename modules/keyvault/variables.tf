variable "name" {
  description = "Key Vault name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing Key Vault"
  type        = string
}

variable "location" {
  description = "Expected location"
  type        = string
}

variable "tenant_id" {
  description = "Expected tenant ID"
  type        = string
}

variable "enabled_for_disk_encryption" {
  description = "Disk encryption flag"
  type        = bool
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention"
  type        = number
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
