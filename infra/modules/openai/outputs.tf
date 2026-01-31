output "id" {
  description = "The ID of the Azure OpenAI resource"
  value       = azurerm_cognitive_account.openai.id
}

output "endpoint" {
  description = "The endpoint URL of the Azure OpenAI resource"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "primary_access_key" {
  description = "The primary access key for the Azure OpenAI resource"
  value       = azurerm_cognitive_account.openai.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for the Azure OpenAI resource"
  value       = azurerm_cognitive_account.openai.secondary_access_key
  sensitive   = true
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned managed identity"
  value       = azurerm_cognitive_account.openai.identity[0].principal_id
}

output "deployment_ids" {
  description = "Map of deployment names to their IDs"
  value       = { for k, v in azurerm_cognitive_deployment.models : k => v.id }
}
