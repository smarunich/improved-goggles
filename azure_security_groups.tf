resource "azurerm_network_security_group" "ctrl_sg" {
  name                = "ctrl_sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.avi_resource_group.name

  security_rule {
    name                       = "permit_inbound_all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    Owner = var.owner
  }
}