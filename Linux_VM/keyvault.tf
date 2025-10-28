data "azurerm_client_config" "current"{}

resource "random_uuid" "appvaultkey" {
  
}

resource "azurerm_key_vault" "appvault" {
  name                       = join("",["appvault",substr(random_uuid.appvaultkey.result,0,8)])
  location                   = var.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled = false
  sku_name = "standard"
  depends_on = [ random_uuid.appvaultkey ]
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.appvault.id
}