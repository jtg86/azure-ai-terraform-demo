variable "location" {
  description = "Azure region for most resources"
  type        = string
  default     = "norwayeast"
}

variable "openai_location" {
  description = "Azure region for OpenAI (limited availability)"
  type        = string
  default     = "swedencentral"
}

variable "enable_alerts" {
  description = "Whether to enable monitoring alerts"
  type        = bool
  default     = true
}

variable "action_group_id" {
  description = "Action group ID for alert notifications"
  type        = string
  default     = null
}
