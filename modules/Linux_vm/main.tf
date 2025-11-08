resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.location
}

resource "azurerm_public_ip" "vm0" {
  name                = "pip-${var.application_name}-${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  allocation_method   = "Static"
  depends_on          = [azurerm_resource_group.main]
}

data "azurerm_subnet" "zero" {
  name                 = "snet-0"
  virtual_network_name = "app-network"
  resource_group_name  = "rg-network-dev"
}

resource "azurerm_network_interface" "appinterface" {
  name                = "nic-${var.application_name}-${var.environment_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.zero.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm0.id
  }

  depends_on = [
    azurerm_public_ip.vm0
  ]
}

resource "azurerm_linux_virtual_machine" "vm0" {
  name                = "vm0${var.application_name}${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.appinterface.id,
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
  tls_private_key.azureuser_ssh]
}

