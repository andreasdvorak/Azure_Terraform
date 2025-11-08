output "virtual_network_address_space" {
  description = "Name of Virtual Network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_zero_address_prefixes" {
  description = "Address prefixes of subnet 0"
  value       = azurerm_subnet.zero.address_prefixes
}

output "subnet_one_address_prefixes" {
  description = "ID of Subnet 1"
  value       = azurerm_subnet.one.address_prefixes
}