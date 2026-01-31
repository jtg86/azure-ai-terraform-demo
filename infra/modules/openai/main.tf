/**
 * # Azure OpenAI Module
 *
 * This module provisions an Azure OpenAI Service with configurable model deployments.
 * Supports GPT-4, GPT-3.5-Turbo, and embedding models.
 */

resource "azurerm_cognitive_account" "openai" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = var.sku_name
  custom_subdomain_name = var.custom_subdomain_name

  identity {
    type = "SystemAssigned"
  }

  network_acls {
    default_action = var.public_network_access_enabled ? "Allow" : "Deny"
    ip_rules       = var.allowed_ip_ranges
  }

  tags = var.tags
}

resource "azurerm_cognitive_deployment" "models" {
  for_each = { for deployment in var.model_deployments : deployment.name => deployment }

  name                 = each.value.name
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = "Standard"
    capacity = each.value.capacity
  }
}

# Diagnostic settings for monitoring
resource "azurerm_monitor_diagnostic_setting" "openai" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_cognitive_account.openai.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "Audit"
  }

  enabled_log {
    category = "RequestResponse"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
