output "app_service_default_hostname" {
  value       = azurerm_linux_web_app.main.default_hostname
  description = "Default hostname of the App Service"
}

output "app_service_id" {
  value       = azurerm_linux_web_app.main.id
  description = "ID of the Linux Web App"
}