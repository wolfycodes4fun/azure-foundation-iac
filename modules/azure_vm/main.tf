resource "azurerm_network_interface" "nic" {
  for_each = toset(var.zones)

  name                = "app-${var.environment}-zone${each.value}-nic"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.pvt_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "primary_vm" {
  for_each = toset(var.zones)

  name                = "app-${var.environment}-zone${each.value}-vm"
  resource_group_name = var.resource_group_name
  location            = var.region
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  zone                = each.value

  network_interface_ids = [
    azurerm_network_interface.nic[each.value].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
