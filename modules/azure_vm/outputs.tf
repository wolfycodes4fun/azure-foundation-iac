output "nic_ids" {
  description = "List of all the IDs of the NICs created"
  value       = azurerm_network_interface.nic
}