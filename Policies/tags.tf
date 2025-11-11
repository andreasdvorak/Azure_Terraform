
resource "azurerm_policy_definition" "require_rg_tags" {
  name         = "require-rg-tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Resource Groups muss have the tags environment and responsibility"
  description  = "Make shure, that all Resource Groups have the tags environment and responsibility."

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Resources/subscriptions/resourceGroups"
      },
      {
        "anyOf": [
          {
            "field": "tags['environment']",
            "exists": "false"
          },
          {
            "field": "tags['responsibility']",
            "exists": "false"
          }
        ]
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "assign_rg_tags" {
  name                 = "assign-require-rg-tags"
  policy_definition_id = azurerm_policy_definition.require_rg_tags.id
  subscription_id      = data.azurerm_subscription.current.id
}

