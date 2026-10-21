terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "registry.opentofu.org/hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}