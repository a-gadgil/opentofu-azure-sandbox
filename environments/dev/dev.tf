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

# --- Variables with Validation & Fallbacks ---
variable "environment" {
  type        = string
  default     = "dev"
  description = "Target deployment environment name"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be strictly set to 'dev', 'staging', or 'prod'."
  }
}

variable "vnet_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Virtual network address space CIDR"

  validation {
    condition     = can(cidrnetmask(var.vnet_cidr))
    error_message = "The provided vnet_cidr must be a valid IPv4 CIDR block notation."
  }
}

variable "inbound_rules" {
  type = map(object({
    priority = number
    direction = string
    access = string
    protocol = string
  }))
  default = {
    "allow_ssh" = {
      priority = 100
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
    }
  }
}

# --- Locals using try and coalesce ---
locals {
  app_tier = coalesce(try(var.environment, null), "Standard")
}

# --- Resources ---
resource "azurerm_resource_group" "dev" {
  name     = "sample-resource"
  location = "Central India"
}

module "storage" {
  source                   = "../../modules/azure_storage"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location
  environment              = var.environment
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# --- Outputs ---
output "dev_storage_account_name" {
  value       = module.storage.storage_account_name
  description = "Dev storage account name"
}