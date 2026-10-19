output "private_subnet_id" {
  description = "ID of the defined private subnet"
  value       = azurerm_subnet.pvt_subnet.id
}

output "bastion_host_ip" {
  description = "Public IP associated with the Bastion host"
  value = azurerm_public_ip.bastion_pip
}