output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the provisioned storage account"
}