resource "azurerm_mssql_server" "sql_server" {
  name                         = "app-${var.environment}-${var.region}-sqldb"
  resource_group_name          = var.resource_group_name
  location                     = var.region
  version                      = var.sql_version
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
}