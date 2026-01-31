output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "app_service_url" {
  description = "URL of the deployed application"
  value       = module.app_service.url
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = module.app_service.name
}

output "openai_endpoint" {
  description = "Azure OpenAI endpoint URL"
  value       = module.openai.endpoint
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = module.key_vault.vault_uri
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = module.monitoring.log_analytics_workspace_id
}
