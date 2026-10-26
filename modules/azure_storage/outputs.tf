output "storage_account_name" {
  value = azurerm_storage_account.primary.name
}

output "primary_access_key" {
  value = azurerm_storage_account.primary.primary_access_key
  sensitive = true
}



