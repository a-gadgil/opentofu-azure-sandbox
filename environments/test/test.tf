# environments/test.tf

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

resource "azurerm_resource_group" "test" {
  name     = "rg-test"
  location = "East US"
}

module "compute" {
  source              = "../../modules/azure_compute"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  environment         = "test"
  vm_size             = "Standard_B1s"
}

output "test_vm_private_ip" {
  value       = module.compute.vm_private_ip
  description = "Private IP of the test virtual machine"
}