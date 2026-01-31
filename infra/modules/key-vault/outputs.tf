output "id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "tenant_id" {
  description = "The tenant ID of the Key Vault"
  value       = azurerm_key_vault.main.tenant_id
}
