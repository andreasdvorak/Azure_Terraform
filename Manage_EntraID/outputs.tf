#output "azuread_group_remote_access_user" {
#  description = "Name of the remote access user group"
#  value       = azuread_client_config.remote_access_user.name
#}

output "sp_object_id" {
  description = "Service Principal Object ID"
  value       = data.azuread_client_config.current.client_id
}

data "azuread_service_principal" "current_sp" {
  object_id = data.azuread_client_config.current.object_id
}

output "sp_display_name" {
  description = "Service Principal display name"
  value       = data.azuread_service_principal.current_sp.display_name
}
