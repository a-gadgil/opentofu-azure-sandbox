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

