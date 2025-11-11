resource "azuread_group" "policy_reader" {
  display_name     = "policy_reader"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

locals {
  policy_reader_map = { for index, element in var.policy-reader-list : element => index }
}

data "azuread_service_principal" "terraform_sp_policy_reader" {
  for_each     = local.terraform_sp_map
  display_name = each.key
}

resource "azuread_group_member" "policy_reader" {
  for_each         = local.policy_reader_map
  group_object_id  = azuread_group.policy_reader.object_id
  member_object_id = data.azuread_service_principal.terraform_sp_policy_reader[each.key].object_id
}

data "azuread_group" "policy_reader" {
  display_name = "policy_reader"
}

# Only possible with EntraID P1/P2 licenses
#resource "azurerm_role_definition" "policy_reader" {
#  name        = "Policy Reader"
#  scope       = "/subscriptions/${var.subscription_id}"
#  description = "Allow read of Azure Policies and Initiatives."
#
#  permissions {
#    actions = [
#      "Microsoft.Authorization/policyDefinitions/read",
#      "Microsoft.Authorization/policySetDefinitions/read",
#      "Microsoft.Authorization/policyAssignments/read"
#    ]
#    not_actions = []
#  }
#
#  assignable_scopes = [
#    "/subscriptions/${var.subscription_id}"
#  ]
#}
#
#resource "azurerm_role_assignment" "policy_reader_group" {
#  scope                = "/subscriptions/${var.subscription_id}"
#  role_definition_name = azurerm_role_definition.policy_reader.role_definition_resource_id
#  principal_id         = azuread_group.policy_reader.id
#}
