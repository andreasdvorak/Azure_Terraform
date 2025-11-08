output "public_ip_addresse_vm0" {
  description = "Public IP of VM0"
  value       = azurerm_public_ip.vm0.ip_address
}