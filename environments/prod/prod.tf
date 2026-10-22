# environments/prod.tf

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-tfstate-prod"
  #   storage_account_name = "sttfstateprod01"
  #   container_name       = "tfstate"
  #   key                  = "prod.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "prod" {
  name     = "rg-prod"
  location = "East US"
}

module "compute" {
  source              = "../../modules/azure_compute"
  resource_group_name = azurerm_resource_group.prod.name
  location            = azurerm_resource_group.prod.location
  environment         = "prod"
  vm_size             = "Standard_D2s_v3" # Production compute tier
}

output "prod_vm_private_ip" {
  value       = module.compute.vm_private_ip
  description = "Private IP of the production virtual machine"
}