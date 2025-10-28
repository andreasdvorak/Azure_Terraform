resource "azurerm_resource_group" "main" {
  location = var.location
  name     = "rg-${var.application}-${var.env}"
}

resource "azurem_log_analytics_workspace" "main" {
  name                = "log-${var.application}-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}