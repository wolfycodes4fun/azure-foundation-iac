output "private_subnet_id" {
  description = "ID of the defined private subnet"
  value       = azurerm_subnet.pvt_subnet.id
}