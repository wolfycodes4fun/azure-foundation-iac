terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
    name = "infra-eus-dev-rg"
    location = "East US"
}

module "azure_vnet" {
    source = "../../modules/azure_vnet"

    vnet_name = "infra-eus-dev-vnet"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}