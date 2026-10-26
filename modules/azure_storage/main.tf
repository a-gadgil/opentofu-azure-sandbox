resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "primary" {
  name                     = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_storage_container" "data" {
  name                  = "data-container"
  storage_account_name  = azurerm_storage_account.primary.name
  container_access_type = "private"
}

moved {
  from = azurerm_storage_account.main
  to   = azurerm_storage_account.primary
}
