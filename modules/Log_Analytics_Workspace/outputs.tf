output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_resource_group" {
  value = azurerm_log_analytics_workspace.main.resource_group_name
}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}
