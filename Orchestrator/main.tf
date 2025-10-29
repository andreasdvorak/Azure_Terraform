module "Log_Analytics_Workspace" {
  source              = "../modules/Log_Analytics_Workspace"
  environment_name    = var.environment_name
  application_name    = var.log_analytics_workspace_application_name
}

module "KeyVault" {
  source            = "../modules/KeyVault"
  environment_name  = var.environment_name
  application_name  = var.keyvault_application_name
  tenant_id         = var.tenant_id
  subscription_id   = var.subscription_id

  # Parameter from Log_Analytics_Workspace
  log_analytics_workspace_id = module.Log_Analytics_Workspace.workspace_id

  depends_on          = [module.Log_Analytics_Workspace]
}