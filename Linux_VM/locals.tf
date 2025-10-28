locals {
  // allowed locations
  allowed_locations = ["westeurope", "northeurope"]

  # allowed environments
  allowed_environments = ["dev", "test", "prod"]
  
  # minimum number of vms
  min_vms = 1
  # maximun number of vms
  max_vms = 5

  # allowed ports
  networksecuritygroup_rules=[
    {
      priority=200
      destination_port_range="22"
    },
    {
      priority=300
      destination_port_range="80"
    },    
  ]
}