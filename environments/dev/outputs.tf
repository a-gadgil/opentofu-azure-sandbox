output "vm_id" {
  value       = module.compute.vm_id
  description = "The resource ID of the development Virtual Machine"
}

output "vm_private_ip" {
  value       = module.compute.vm_private_ip
  description = "The private IP address of the development Virtual Machine"
}