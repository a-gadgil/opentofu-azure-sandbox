variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, test, prod)"
  type        = string
}

variable "account_tier" {
  description = "The tier of the storage account (e.g., Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account (e.g., LRS, GRS, ZRS)"
  type        = string
  default     = "LRS"
}