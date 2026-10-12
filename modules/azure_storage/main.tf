resource "azurerm_storage_account" "storage_account" {
  name                            = "${var.project_name}-${var.environment}-${var.region}-storageacc"
  resource_group_name             = var.resource_group_name
  location                        = var.region
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Hot"
  default_to_oauth_authentication = true

  blob_properties {
    change_feed_enabled = true
    versioning_enabled  = true

    delete_retention_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 7
    }
  }
}