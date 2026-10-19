output "nics" {
  description = "List of all the NICs created"
  value       = azurerm_network_interface.nic
}