resource "azuread_group" "terraform_sp" {
  display_name     = "${var.environment_name}-terraform_sp"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

# Create a map from the list of service principals
# With using for_each we can iterate over the list and create resources for each SP
# If using count and the sorting changes, the resources will be destroyed and recreated
locals {
  terraform_sp_map = { for index, element in var.terraform-sp-list : element => index }
}

data "azuread_service_principal" "terraform_sp" {
  for_each     = local.terraform_sp_map
  display_name = each.key
}

resource "azuread_group_member" "terraform_sp" {
  for_each         = local.terraform_sp_map
  group_object_id  = azuread_group.terraform_sp.object_id
  member_object_id = data.azuread_service_principal.terraform_sp[each.key].object_id
}