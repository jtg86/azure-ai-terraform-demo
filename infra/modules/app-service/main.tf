/**
 * # Azure App Service Module
 *
 * This module provisions an Azure App Service with managed identity
 * for secure access to other Azure resources.
 */

resource "azurerm_service_plan" "main" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.sku_name

  tags = var.tags
}

resource "azurerm_linux_web_app" "main" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on           = var.always_on
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"

    application_stack {
      python_version = var.python_version
    }

    cors {
      allowed_origins = var.cors_allowed_origins
    }
  }

  app_settings = merge(
    {
      "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
      "WEBSITE_RUN_FROM_PACKAGE"       = "0"
    },
    var.app_settings
  )

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    application_logs {
      file_system_level = "Information"
    }
  }

  tags = var.tags
}

# Diagnostic settings for monitoring
resource "azurerm_monitor_diagnostic_setting" "app" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "diag-${var.app_name}"
  target_resource_id         = azurerm_linux_web_app.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
