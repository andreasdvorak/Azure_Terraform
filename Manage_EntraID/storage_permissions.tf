resource "azuread_group" "storage_container_dev_read_access" {
  display_name     = "dev-storage_container_read_access"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

resource "azuread_group" "storage_container_prod_read_access" {
  display_name     = "prod-storage_container_read_access"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}
