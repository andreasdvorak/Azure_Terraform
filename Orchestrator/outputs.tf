output "log_analytics_workspace_id" {
  value = module.Log_Analytics_Workspace.workspace_id
}

output "keyvault_id" {
  value = module.KeyVault.azurerm_key_vault
}

output "virtual_network_address_space" {
  description = "Address space virtual network"
  value       = module.Network.virtual_network_address_space
}

output "subnet_zero_adresse_prefixes" {
  description = "Address prefixes of subnet 0"
  value       = module.Network.subnet_zero_address_prefixes
}

output "subnet_one_adresse_prefixes" {
  description = "Address prefixes of subnet 1"
  value       = module.Network.subnet_one_address_prefixes
}

output "public_ip_addresse_vm0" {
  description = "Public IP of VM0"
  value       = module.Linux_vm.public_ip_addresse_vm0
}