variable "app_name" {
  description = "Name of the App Service"
  type        = string
}

variable "service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the App Service Plan"
  type        = string
  default     = "B1"
}

variable "python_version" {
  description = "Python version for the App Service"
  type        = string
  default     = "3.11"
}

variable "always_on" {
  description = "Whether the app should be always on"
  type        = bool
  default     = false
}

variable "app_settings" {
  description = "Application settings for the App Service"
  type        = map(string)
  default     = {}
}

variable "cors_allowed_origins" {
  description = "List of allowed CORS origins"
  type        = list(string)
  default     = []
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
