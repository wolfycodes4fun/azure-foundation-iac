terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "=3.10.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-be-rg"
    storage_account_name = "devstatefiles12345"
    container_name       = "statefiles"
    key                  = "networking/terraform.tf"

    use_azuread_auth = true
  }
}