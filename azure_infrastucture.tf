resource "azurerm_resource_group" "avi_resource_group" {
  name     = "${var.id}_resource_group"
  location = var.location
  tags = {
    Owner = var.owner
  }
}

resource "azurerm_virtual_network" "avi_vnet" {
  name                = "${var.id}_vnet"
  location            = var.location
  address_space       = [ var.vnet_cidr ]
  resource_group_name = azurerm_resource_group.avi_resource_group.name
  tags = {
    Owner = var.owner
  }
}

resource "azurerm_subnet" "avi_pubnet" {
  name                 = "${var.id}_VIP_network"
  resource_group_name = azurerm_resource_group.avi_resource_group.name
  virtual_network_name = azurerm_virtual_network.avi_vnet.name
  address_prefix       = cidrsubnet(var.vnet_cidr, 8, 0)
}

resource "azurerm_subnet" "avi_privnet" {
  name                 =  "${var.id}_server_network"
  resource_group_name  = azurerm_resource_group.avi_resource_group.name
  virtual_network_name = azurerm_virtual_network.avi_vnet.name
  address_prefix       = cidrsubnet(var.vnet_cidr, 8, 1)
}

resource "azurerm_subnet" "avi_mgmtnet" {
  name                 =  "${var.id}_management_network"
  resource_group_name  = azurerm_resource_group.avi_resource_group.name
  virtual_network_name = azurerm_virtual_network.avi_vnet.name
  address_prefix       = cidrsubnet(var.vnet_cidr, 8, 2)
}