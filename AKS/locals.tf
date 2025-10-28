locals {
  # The initial quantity of worker nodes
  node_count = 2
  # Location of the resource group
  resource_group_location = "North Europe"
  # The admin username for the new cluster
  username = "azureadmin"
  # vm_size for azure aks nodes
  vm_size = "Standard_B2s"

  tags_environment = "AKS Demo"
}