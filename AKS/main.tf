# Generate random pet name
resource "random_pet" "pet_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = local.resource_group_location
  name     = random_pet.pet_name.id
}

resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = "cluster_${random_pet.pet_name.id}"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dns"
  sku_tier            = "Free"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = local.vm_size
    node_count = local.node_count
  }
 
  tags = {
    environment = local.tags_environment
  }
}