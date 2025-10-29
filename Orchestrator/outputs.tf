output "log_analytics_workspace_id" {
  value = module.Log_Analytics_Workspace.workspace_id
}

output "keyvault_id" {
  value = module.KeyVault.azurerm_key_vault
}
