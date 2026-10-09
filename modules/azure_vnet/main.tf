resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-${var.environment}-${var.region}-vnet"
  location            = var.region
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

resource "azurerm_network_security_group" "nsg" {
  depends_on = [azurerm_subnet.bastion_subnet]

  name                = var.nsg_01_name
  location            = var.region
  resource_group_name = var.resource_group_name

  security_rule {
    name = "AllowBastionInbound"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = ["22", "3389"]
    source_address_prefix = azurerm_subnet.bastion_subnet.address_prefixes[0]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.pvt_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_subnet_address_space
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "${var.project_name}-${var.environment}-bastion-pip"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "${var.project_name}-${var.environment}-bastion-host"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "config1"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}