resource "azurerm_public_ip" "lb_pip" {
  name                = var.pip_name
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "app_lb" {
  name                = var.app_lb_name
  location            = var.region
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "lb-pip"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "be_address_pool" {
  loadbalancer_id = azurerm_lb.app_lb.id
  name            = var.be_pool_name
}

resource "azurerm_network_interface_backend_address_pool_association" "be_address_pol_nic_assoc" {
  for_each = var.nic_ids

  network_interface_id    = each.value.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.be_address_pool.id
}