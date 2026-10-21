output "app_service_default_hostname" {
  value       = module.app_service.app_service_default_hostname
  description = "Default hostname of the App Service"
}

output "app_service_id" {
  value       = module.app_service.app_service_id
  description = "ID of the Linux Web App"
}