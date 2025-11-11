data "azurerm_storage_account" "sa" {
  name                = var.backend_storage_account
  resource_group_name = var.backend_resource_group
}

data "azurerm_storage_container" "container" {
  name                 = var.backend_storage_container
  storage_account_name = data.azurerm_storage_account.sa.name
}

# RBAC-assignment for Storage Blob Data Reader role to the group for the specified container
resource "azurerm_role_assignment" "container_read_access" {
  scope                = data.azurerm_storage_container.container.resource_manager_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azuread_group.storage_container_prod_read_access.object_id
}