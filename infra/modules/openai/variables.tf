variable "name" {
  description = "Name of the Azure OpenAI resource"
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
  description = "SKU name for the OpenAI resource"
  type        = string
  default     = "S0"
}

variable "custom_subdomain_name" {
  description = "Custom subdomain name for the OpenAI endpoint"
  type        = string
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

variable "model_deployments" {
  description = "List of model deployments to create"
  type = list(object({
    name          = string
    model_name    = string
    model_version = string
    capacity      = number
  }))
  default = [
    {
      name          = "gpt-35-turbo"
      model_name    = "gpt-35-turbo"
      model_version = "0613"
      capacity      = 10
    }
  ]
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
