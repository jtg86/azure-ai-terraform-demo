/**
 * # Azure Monitoring Module
 *
 * This module provisions Azure Monitor resources including
 * Log Analytics Workspace and Application Insights.
 */

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_in_days

  tags = var.tags
}

resource "azurerm_application_insights" "main" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"

  tags = var.tags
}

# Alert rule for high error rate
resource "azurerm_monitor_metric_alert" "high_error_rate" {
  count = var.enable_alerts ? 1 : 0

  name                = "alert-high-error-rate-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when error rate exceeds threshold"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = var.error_rate_threshold
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}

# Alert rule for high response time
resource "azurerm_monitor_metric_alert" "high_response_time" {
  count = var.enable_alerts && var.action_group_id != null ? 1 : 0

  name                = "alert-high-response-time-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_application_insights.main.id]
  description         = "Alert when response time exceeds threshold"
  severity            = 3
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.response_time_threshold_ms
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}
