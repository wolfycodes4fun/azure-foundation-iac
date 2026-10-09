data "azurerm_client_config" "current_user" {}

resource "azurerm_user_assigned_identity" "db_umid" {
  location            = var.region
  name                = "app-${var.environment}-${var.region}-umid"
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault" "main_kv" {
  name                       = "${var.environment}-kv1"
  location                   = var.region
  resource_group_name        = var.resource_group_name
  rbac_authorization_enabled = true
  sku_name                   = "standard"
  tenant_id                  = azurerm_user_assigned_identity.db_umid.tenant_id
}

resource "azurerm_role_assignment" "db_umid_kv_assoc" {
  scope                = azurerm_key_vault.main_kv.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.db_umid.principal_id
}

resource "azurerm_role_assignment" "tf_user_kv_assoc" {
  scope              = azurerm_key_vault.main_kv.id
  role_definition_id = "Key Vault Crypto Officer"
  principal_id       = data.azurerm_client_config.current_user.object_id
}

resource "azurerm_key_vault_key" "tde_key" {
  depends_on = [azurerm_key_vault.main_kv]

  name         = "sqldb-tde-key"
  key_vault_id = azurerm_key_vault.main_kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = ["unwrapKey", "wrapKey"]
}

resource "azurerm_mssql_server" "sql_server" {
  name                = "app-${var.environment}-${var.region}-sqldb"
  resource_group_name = var.resource_group_name
  location            = var.region
  version             = var.sql_version
  minimum_tls_version = "1.2"

  azuread_administrator {
    login_username              = azurerm_user_assigned_identity.db_umid.name
    object_id                   = azurerm_user_assigned_identity.db_umid.principal_id
    azuread_authentication_only = true
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.db_umid.id]
  }
}