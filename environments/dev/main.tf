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

  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment
  project_name        = var.project_name

  # Private subnet configuration
  pvt_subnet_name = "${var.region}-${var.environment}-pvt-subnet"

  # Public subnet configuration
  public_subnet_name = "${var.region}-${var.environment}-public-subnet"
}

module "azure_vm" {
  source = "../../modules/azure_vm"

  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment

  # VM configuration
  vm_size        = "Standard_D2as_v4"
  admin_password = var.admin_password
  zones          = ["1", "2"]

  # NIC configuration
  pvt_subnet_id = module.azure_vnet.private_subnet_id
}

module "azure_lb" {
  source = "../../modules/azure_lb"

  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Load balancer configuration
  pip_name    = "${var.project_name}-${var.environment}-lb-pip1"
  app_lb_name = "${var.project_name}-${var.environment}-lb"
  nic_ids     = module.azure_vm.nic_ids
}

module "azure_sql" {
  source = "../../modules/azure_sql"

  region              = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  environment         = var.environment

  # SQL Server instance configuration
  sql_version = var.sql_version
}
