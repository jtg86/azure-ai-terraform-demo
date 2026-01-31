/**
 * # Production Environment
 *
 * This configuration deploys the AI infrastructure in a production environment
 * with enhanced reliability and security settings.
 */

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Uncomment to use remote backend
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "stterraformstate"
  #   container_name       = "tfstate"
  #   key                  = "ai-demo-prod.tfstate"
  # }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

# Random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  environment = "prod"
  location    = var.location
  suffix      = random_string.suffix.result

  tags = {
    Environment = local.environment
    Project     = "ai-demo"
    ManagedBy   = "terraform"
    CostCenter  = "production"
  }

  # Resource names
  resource_group_name = "rg-ai-demo-${local.environment}"
  openai_name         = "oai-demo-${local.environment}-${local.suffix}"
  app_name            = "app-ai-demo-${local.environment}-${local.suffix}"
  keyvault_name       = "kv-ai-${local.environment}-${local.suffix}"
  log_analytics_name  = "log-ai-demo-${local.environment}"
  app_insights_name   = "appi-ai-demo-${local.environment}"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

# Monitoring Module (Production settings)
module "monitoring" {
  source = "../../modules/monitoring"

  log_analytics_name  = local.log_analytics_name
  app_insights_name   = local.app_insights_name
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  environment         = local.environment
  retention_in_days   = 90  # Longer retention for prod
  enable_alerts       = var.enable_alerts
  action_group_id     = var.action_group_id

  tags = local.tags
}

# Azure OpenAI Module (Production settings)
module "openai" {
  source = "../../modules/openai"

  name                  = local.openai_name
  location              = var.openai_location
  resource_group_name   = azurerm_resource_group.main.name
  custom_subdomain_name = local.openai_name

  model_deployments = [
    {
      name          = "gpt-4"
      model_name    = "gpt-4"
      model_version = "0613"
      capacity      = 20
    },
    {
      name          = "gpt-35-turbo"
      model_name    = "gpt-35-turbo"
      model_version = "0613"
      capacity      = 30
    }
  ]

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = local.tags
}

# Key Vault Module (Production settings)
module "key_vault" {
  source = "../../modules/key-vault"

  name                     = local.keyvault_name
  location                 = local.location
  resource_group_name      = azurerm_resource_group.main.name
  purge_protection_enabled = true  # Enable for production
  soft_delete_retention_days = 90

  secrets_officer_principal_ids = [data.azurerm_client_config.current.object_id]
  openai_api_key                = module.openai.primary_access_key

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = local.tags

  depends_on = [module.openai]
}

# App Service Module (Production settings)
module "app_service" {
  source = "../../modules/app-service"

  app_name            = local.app_name
  service_plan_name   = "plan-ai-demo-${local.environment}"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name       = "P1v3"  # Premium tier for production
  python_version = "3.11"
  always_on      = true    # Keep app warm in production

  app_settings = {
    "AZURE_OPENAI_ENDPOINT"     = module.openai.endpoint
    "AZURE_OPENAI_DEPLOYMENT"   = "gpt-4"
    "AZURE_KEYVAULT_URL"        = module.key_vault.vault_uri
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.monitoring.app_insights_connection_string
  }

  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  tags = local.tags

  depends_on = [module.key_vault]
}

# Grant App Service access to Key Vault secrets
resource "azurerm_role_assignment" "app_keyvault_access" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.app_service.identity_principal_id
}

# Grant App Service access to OpenAI
resource "azurerm_role_assignment" "app_openai_access" {
  scope                = module.openai.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = module.app_service.identity_principal_id
}

# Data source for current client
data "azurerm_client_config" "current" {}
