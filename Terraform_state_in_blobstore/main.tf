# Generate random resource group name
resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false
}

resource "azurerm_resource_group" "storage-rg" {
  location = var.location
  name     = "rg-st-${var.env}"
}

# If you want to create the storage account with Terraform
resource "azurerm_storage_account" "main" {
  name                     = "st${random_string.suffix.id}${var.env}"
  resource_group_name      = azurerm_resource_group.storage-rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env}"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}