variable "log_analytics_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
}

variable "app_insights_name" {
  description = "Name of the Application Insights resource"
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

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
  default     = "dev"
}

variable "log_analytics_sku" {
  description = "SKU for the Log Analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Data retention in days"
  type        = number
  default     = 30
}

variable "enable_alerts" {
  description = "Whether to enable metric alerts"
  type        = bool
  default     = false
}

variable "action_group_id" {
  description = "ID of the action group for alerts"
  type        = string
  default     = null
}

variable "error_rate_threshold" {
  description = "Threshold for error rate alerts"
  type        = number
  default     = 10
}

variable "response_time_threshold_ms" {
  description = "Threshold for response time alerts in milliseconds"
  type        = number
  default     = 5000
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
