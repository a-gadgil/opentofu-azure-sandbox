# environments/staging.tf

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

resource "azurerm_resource_group" "stag" {
  name     = "rg-stag"
  location = "East US"
}

module "compute" {
  source              = "../../modules/azure_compute"
  resource_group_name = azurerm_resource_group.stag.name
  location            = azurerm_resource_group.stag.location
  environment         = "staging"
  vm_size             = "Standard_B2s" # Slightly larger for pre-prod validation
}

output "staging_vm_private_ip" {
  value       = module.compute.vm_private_ip
  description = "Private IP of the staging virtual machine"
}

module "storage" {
  source                   = "../../modules/azure_storage"
  resource_group_name      = azurerm_resource_group.stag.name
  location                 = azurerm_resource_group.stag.location
  environment              = "stag"
  account_tier             = "Standard"
  account_replication_type = "ZRS" # Zone-redundant for staging pre-prod fidelity
}

output "stag_storage_account_name" {
  value       = module.storage.storage_account_name
  description = "Staging storage account name"
}