terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.75.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.1.0"
    }

  }
}

provider "azurerm" {
  features {}
}
provider "local" {}
provider "tls" {}
provider "external" {}
data "azurerm_client_config" "azurerm_client_config" {}
