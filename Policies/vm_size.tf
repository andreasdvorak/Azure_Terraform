resource "azurerm_policy_definition" "allow_vm_sizes" {
  name         = "allow-vm-sizes"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Only allow specific VM sizes"
  description  = "This policy restricts the creation of virtual machines to specific sizes."

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Compute/virtualMachines"
      },
      {
        "not": {
          "field": "Microsoft.Compute/virtualMachines/sku.name",
          "in": ${jsonencode(var.allowed_vm_sizes)}
        }
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "assign_vm_sizes" {
  name                 = "assign-vm-sizes"
  policy_definition_id = azurerm_policy_definition.allow_vm_sizes.id
  subscription_id      = data.azurerm_subscription.current.id
}