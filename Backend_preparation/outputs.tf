output "resource_group_name" {
  value = azurerm_resource_group.storage-rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_container" {
  value = azurerm_storage_container.tfstate.name
}