output "id" {
  description = "The ID of the App Service"
  value       = azurerm_linux_web_app.main.id
}

output "name" {
  description = "The name of the App Service"
  value       = azurerm_linux_web_app.main.name
}

output "default_hostname" {
  description = "The default hostname of the App Service"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "url" {
  description = "The URL of the App Service"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned managed identity"
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}

output "identity_tenant_id" {
  description = "The tenant ID of the system-assigned managed identity"
  value       = azurerm_linux_web_app.main.identity[0].tenant_id
}

output "service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.main.id
}
