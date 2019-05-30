# Terraform definition for the lab Controllers

resource "azurerm_public_ip" "ctrl_eip" {
  count  = var.student_count
  name                         =  "${var.id}_student${count.index + 1}_ctrl_eip"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.avi_resource_group.name
  allocation_method           = "Dynamic"
  tags = {
    Owner = var.owner
  }
}

resource "azurerm_network_interface" "ctrl_nic" {
  count         = var.student_count
  name                      = "${var.id}_student${count.index + 1}_ctrl_nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.avi_resource_group.name
  network_security_group_id = azurerm_network_security_group.ctrl_sg.id
  ip_configuration {
    name                          =  "${var.id}_student${count.index + 1}_ctrl_ip"
    subnet_id                     =  azurerm_subnet.avi_pubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ctrl_eip[count.index].id
  }
  tags = {
    Owner = var.owner
  }
}

resource "azurerm_virtual_machine" "ctrl" {
  count         = var.student_count
  name          = "${var.id}_student${count.index + 1}_controller"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.avi_resource_group.name
  vm_size                   = var.flavour_avi
  network_interface_ids     = [ azurerm_network_interface.ctrl_nic[count.index].id ]

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${var.id}_student${count.index + 1}_ctrl_ssd"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
    disk_size_gb      =  var.vol_size_avi
  }

  storage_image_reference {
    id = var.azure_avi_image_id
  }

  os_profile {
    computer_name = "student${count.index + 1}"
    admin_username = var.avi_backup_admin_username
    admin_password = var.avi_backup_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Owner = var.owner
  }
}
