resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.location

  tags = {
    environment    = var.environment_name
    responsibility = var.responsibility
  }
}

resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network.name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.virtual_network.address_space]

  depends_on = [azurerm_resource_group.main]
}

resource "azurerm_subnet" "zero" {
  name                 = "snet-0"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.virtual_network.address_space, 2, 0)]

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_subnet" "one" {
  name                 = "snet-1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = [cidrsubnet(var.virtual_network.address_space,
    var.virtual_network.subnet_newbits,
  1)]

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_subnet" "two" {
  name                 = "snet-2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = [cidrsubnet(var.virtual_network.address_space,
    var.virtual_network.subnet_newbits,
  2)]

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_subnet" "three" {
  name                 = "snet-3"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes = [cidrsubnet(var.virtual_network.address_space,
    var.virtual_network.subnet_newbits,
  3)]

  depends_on = [azurerm_virtual_network.main]
}

resource "azurerm_network_security_group" "ssh_remote_access" {
  name                = "nsg-ssh-${var.environment_name}-remote-access"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = chomp(data.http.my_ip.response_body)
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.main]
}

resource "azurerm_subnet_network_security_group_association" "zero_remote_access" {
  subnet_id                 = azurerm_subnet.zero.id
  network_security_group_id = azurerm_network_security_group.ssh_remote_access.id
  depends_on = [
    azurerm_virtual_network.main,
    azurerm_network_security_group.ssh_remote_access
  ]
}

# Get the current user's public IP address
data "http" "my_ip" {
  url = "https://api.ipify.org"
}
