# environments/dev.tf

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Environment-level Resource Group
resource "azurerm_resource_group" "dev" {
  name     = "rg-dev"
  location = "East US"
}

# 2. Calling our Composite Module (Function Call)
module "compute" {
  source              = "../../modules/azure_compute"  # <--- Notice the extra ../
  resource_group_name = azurerm_resource_group.dev.name
  location            = azurerm_resource_group.dev.location
  environment         = "dev"
  vm_size             = "Standard_B1s"
}

# 3. Surfacing Module Outputs
output "dev_vm_private_ip" {
  value       = module.compute.vm_private_ip
  description = "Private IP of the dev virtual machine"
}

module "storage" {
  source                   = "../../modules/azure_storage"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location
  environment              = "dev"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Add your declarative import block right here in the same file
import {
  id = "/subscriptions/828c19cf-1794-450c-a9e0-51b158f737d7/resourceGroups/sample-resource/providers/Microsoft.Storage/storageAccounts/saopentofu"
  to = azurerm_storage_account.imported_manual
}


output "dev_storage_account_name" {
  value       = module.storage.storage_account_name
  description = "Dev storage account name"
}

variable "inbound_rules" {
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {
    "Allow_HTTP" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    "Allow_HTTPS" = {
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-dev-01"
  location            = "eastus"
  resource_group_name = "rg-dev"

  dynamic "security_rule" {
    # Directly iterate over the map. 
    # security_rule.key will be "Allow_HTTP", etc.
    # security_rule.value will be the object containing priority, protocol, etc.
    for_each = var.inbound_rules
    
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