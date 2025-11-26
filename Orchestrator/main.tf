module "Log_Analytics_Workspace" {
  source           = "../modules/Log_Analytics_Workspace"
  environment_name = var.environment_name
  application_name = var.log_analytics_workspace_application_name
  responsibility   = var.responsibility
}

module "KeyVault" {
  source           = "../modules/KeyVault"
  environment_name = var.environment_name
  application_name = var.keyvault_application_name
  responsibility   = var.responsibility
  tenant_id        = var.tenant_id
  subscription_id  = var.subscription_id

  # Parameter from Log_Analytics_Workspace
  log_analytics_workspace_id = module.Log_Analytics_Workspace.workspace_id

  depends_on = [module.Log_Analytics_Workspace]
}

module "Network" {
  source           = "../modules/Network"
  environment_name = var.environment_name
  application_name = var.network_application_name
  responsibility   = var.responsibility
  virtual_network  = var.virtual_network

  depends_on = [module.KeyVault]
}

module "Linux_vm" {
  source           = "../modules/Linux_vm"
  environment_name = var.environment_name
  application_name = var.vm_application_name
  admin_username   = var.admin_username
  os_offer         = var.os_offer
  os_sku           = var.os_sku
  responsibility   = var.responsibility
  vm_size          = var.vm_size

  depends_on = [module.Network]
}
