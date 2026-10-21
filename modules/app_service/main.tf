resource "azurerm_service_plan" "main" {
  name                = "plan-core-api-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"

  tags = {
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}

resource "azurerm_linux_web_app" "main" {
  name                = "app-core-api-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}