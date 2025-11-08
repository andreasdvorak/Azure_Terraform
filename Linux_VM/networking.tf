resource "azurerm_network_security_group" "appnsg" {
  name                = "app-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  dynamic "security_rule" {
    for_each = local.networksecuritygroup_rules
    content {
      name                       = "Allow-${security_rule.value.destination_port_range}"
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  depends_on = [azurerm_resource_group.main]
}

resource "azurerm_subnet_network_security_group_association" "appnsglink" {
  subnet_id                 = azurerm_subnet.subnets.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
  depends_on = [
    azurerm_virtual_network.appnetwork,
    azurerm_network_security_group.appnsg
  ]
}

resource "azurerm_virtual_network" "appnetwork" {
  name                = var.virtual_network.name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.virtual_network.address_space]

  depends_on = [azurerm_resource_group.main]
}

resource "azurerm_subnet" "subnets" {
  name                 = "Subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = var.virtual_network.name
  address_prefixes     = [var.virtual_network.address_space]
  depends_on           = [azurerm_virtual_network.appnetwork]
}
