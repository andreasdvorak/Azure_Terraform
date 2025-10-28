resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.env}"
  location = var.location
}
