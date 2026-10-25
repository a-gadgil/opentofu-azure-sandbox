output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "primary_access_key" {
  value = azurerm_storage_account.main.primary_access_key
  sensitive = true
}



