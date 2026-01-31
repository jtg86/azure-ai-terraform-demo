variable "name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region for the resource"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Key Vault"
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted keys"
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled"
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "Whether to enable RBAC authorization"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled"
  type        = bool
  default     = true
}

variable "allowed_ip_ranges" {
  description = "List of allowed IP ranges for network access"
  type        = list(string)
  default     = []
}

variable "secrets_user_principal_ids" {
  description = "List of principal IDs to grant Key Vault Secrets User role"
  type        = list(string)
  default     = []
}

variable "secrets_officer_principal_ids" {
  description = "List of principal IDs to grant Key Vault Secrets Officer role"
  type        = list(string)
  default     = []
}

variable "openai_api_key" {
  description = "OpenAI API key to store in the vault"
  type        = string
  default     = null
  sensitive   = true
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace for diagnostics"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
