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
