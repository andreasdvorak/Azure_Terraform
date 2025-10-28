output "randomid_appvaultkey" {
  value=substr(random_uuid.appvaultkey.result,0,8)
}

output "public_ip_addresses" {
  description = "List of all public IPs of the VMs"
  value       = [for ip in azurerm_public_ip.appip : ip.ip_address]
}

output "vm_hostnames" {
  description = "Hostnames of all vms"
  value       = [for vm in azurerm_linux_virtual_machine.appvm : vm.name]
}

output "number_of_vms" {
  value = var.number_of_vms
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
