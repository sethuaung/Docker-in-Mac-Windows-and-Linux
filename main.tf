terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.9.0"
    }
  }
}

provider "azurerm" {
  features {}

  resource_group_name  = "TF-blob"
  storage_account_name = "james"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"

}

resource "azurerm_resource_group" "tf-epift" {
  name     = "TF-rg"
  location = "Asia/Rangoon"
}

resource "azurerm_container_group" "cg-epift" {
  name                = "james"
  location            = azurerm_resource_group.tf-epift.location
  resource_group_name = azurerm_resource_group.tf-epift.name

  ip_address_type = "Public"
  dns_name_label  = "dns-felixent"
  os_type         = "Linux"

  container {
    name   = "james"
    image  = "cracalla/web:v1"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}