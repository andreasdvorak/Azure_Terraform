resource "azurerm_network_interface" "appinterface" {
  count               = var.number_of_vms
  name                = "appinterface${count.index}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal${count.index}"
    subnet_id                     = azurerm_subnet.subnets.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.appip[count.index].id
  }

  depends_on = [ 
    azurerm_subnet.subnets,
    azurerm_public_ip.appip
 ]
}

resource "azurerm_public_ip" "appip" {
  count               = var.number_of_vms
  name                = "app-ip-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  allocation_method   = "Static"
  depends_on = [ azurerm_resource_group.main ]
}

resource "azurerm_linux_virtual_machine" "appvm" {
  count               = var.number_of_vms
  name                = "appvm-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.appinterface[count.index].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.azureuser_ssh.public_key_openssh 
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = var.os_offer
    sku       = var.os_sku
    version   = "latest"
  }

  depends_on = [
    azurerm_resource_group.main,
    azurerm_network_interface.appinterface,
    tls_private_key.azureuser_ssh ]
}
