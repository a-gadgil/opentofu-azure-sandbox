output "vm_id" {
  value       = azurerm_linux_virtual_machine.main.id
  description = "ID of the created Virtual Machine"
}

output "vm_private_ip" {
  value       = azurerm_linux_virtual_machine.main.private_ip_address
  description = "Private IP address of the Virtual Machine"
}