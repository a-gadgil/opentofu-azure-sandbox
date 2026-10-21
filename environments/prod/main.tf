data "azurerm_resource_group" "prod" {
  name = "rg-prod-001"
}

module "app_service" {
  source              = "../../modules/app_service"
  resource_group_name = data.azurerm_resource_group.prod.name
  location            = data.azurerm_resource_group.prod.location
  environment         = "prod"
}