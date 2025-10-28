terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }

#  backend "azurerm" {
#    resource_group_name  = "rg-st-dev"
#    storage_account_name = "stsexn6wcs4pdev"
#    container_name       = "tfstate"
#    key                  = "terraform.tfstate"
#  }

}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}
