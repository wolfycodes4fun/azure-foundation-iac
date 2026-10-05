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
  name     = "${var.project_name}-${var.region}-${var.environment}-rg"
  location = var.region
}

module "azure_vnet" {
  source = "../../modules/azure_vnet"

  vnet_name           = "${var.project_name}-${var.region}-${var.environment}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Private subnet configuration
  pvt_subnet_name = "${var.region}-${var.environment}-pvt-subnet"

  # Public subnet configuration
  public_subnet_name = "${var.region}-${var.environment}-public-subnet"
}