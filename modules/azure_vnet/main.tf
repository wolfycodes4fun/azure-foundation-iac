resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "pvt_subnet" {
  name                            = var.pvt_subnet_name
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.vnet.name
  address_prefixes                = var.pvt_subnet_address_space
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.public_subnet_address_space
}