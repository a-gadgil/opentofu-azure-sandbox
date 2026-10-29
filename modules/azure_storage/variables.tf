variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}