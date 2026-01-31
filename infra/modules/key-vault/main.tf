/**
 * # Azure Key Vault Module
 *
 * This module provisions an Azure Key Vault for secure secrets management.
 * Supports RBAC-based access control and soft delete protection.
 */

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.sku_name
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled
  enable_rbac_authorization   = var.enable_rbac_authorization

  network_acls {
    default_action = var.public_network_access_enabled ? "Allow" : "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.allowed_ip_ranges
  }

  tags = var.tags
}

# Grant access to specified principals
resource "azurerm_role_assignment" "secrets_user" {
  for_each = toset(var.secrets_user_principal_ids)

  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "secrets_officer" {
  for_each = toset(var.secrets_officer_principal_ids)

  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.value
}

# Store OpenAI API key if provided
resource "azurerm_key_vault_secret" "openai_key" {
  count = var.openai_api_key != null ? 1 : 0

  name         = "openai-api-key"
  value        = var.openai_api_key
  key_vault_id = azurerm_key_vault.main.id
  content_type = "API Key"

  depends_on = [azurerm_role_assignment.secrets_officer]
}

# Diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "vault" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
