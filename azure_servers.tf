# Terraform definition for the lab Controllers
resource "azurerm_network_interface" "server_nic" {
  count         = var.server_count
  name                      = "server${count.index + 1}_nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.avi_resource_group.name
  network_security_group_id = azurerm_network_security_group.ctrl_sg.id
  ip_configuration {
    name                          =  "server${count.index + 1}_ip"
    subnet_id                     =  azurerm_subnet.avi_privnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    Owner = var.owner
  }
}

resource "azurerm_virtual_machine" "server" {
  count         = var.server_count
  name          = "server${count.index + 1}"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.avi_resource_group.name
  vm_size                   = var.flavour_centos
  network_interface_ids     = [ azurerm_network_interface.server_nic[count.index].id ]

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-RAW"
    version   = "latest"
  }

  storage_os_disk {
    name              = "server${count.index + 1}_ssd"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  os_profile {
    computer_name = "server${count.index + 1}"
    admin_username = var.avi_ssh_admin_username
    admin_password = random_string.ssh_admin_password.result
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.avi_backup_admin_username}/.ssh/authorized_keys"
      key_data = "${trimspace(tls_private_key.generated_access_key.public_key_openssh)} aviadmin@avinetworks"
    }
  }

  depends_on        = [azurerm_virtual_machine.jumpbox]

  tags = {
    Owner                         = var.owner
    Lab_Group                     = "servers"
    Lab_Name                      = "server${count.index + 1}.lab"
    Lab_Timezone                  = var.lab_timezone
  }
}

resource "azurerm_virtual_machine_extension" "server" {
  count                = var.server_count
  name                 = "server${count.index + 1}"
  location             = var.location
  resource_group_name  = azurerm_resource_group.avi_resource_group.name
  virtual_machine_name = azurerm_virtual_machine.server[count.index].name
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/smarunich/improved-goggles/master/provisioning/provision_vm.sh"],
        "commandToExecute": "./provision_vm.sh"
    }
SETTINGS

  tags = {
    Owner = var.owner
  }
}
