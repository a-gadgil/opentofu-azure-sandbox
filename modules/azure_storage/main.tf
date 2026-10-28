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


resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-prod-01"
  location            = "eastus"
  resource_group_name = "rg-prod"

  # The dynamic block loops through var.inbound_rules
  dynamic "security_rule" {
    for_each = var.inbound_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

locals {
  # Filter the map of inbound rules to only include those where access is "Allow"
  allowed_inbound_rules = {
    for name, rule in var.inbound_rules : name => rule
    if rule.access == "Allow"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-dev-01"
  location            = "eastus"
  resource_group_name = "rg-dev-01"

  dynamic "security_rule" {
    for_each = local.allowed_inbound_rules
    
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}