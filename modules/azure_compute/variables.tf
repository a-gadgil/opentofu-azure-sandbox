variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
    description = "The location of the resource group."
    type        = string
}

variable "environment" {
    description = "The environment for the resources (e.g., dev, test, prod)."
    type        = string
}

variable "vm_size" {
    description = "The size of the virtual machine."
    type        = string
}

