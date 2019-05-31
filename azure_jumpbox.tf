# Terraform definition for the lab Controllers

resource "azurerm_public_ip" "jumpbox_eip" {
  name                         =  "${var.id}_jumpbox_eip"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.avi_resource_group.name
  allocation_method           = "Dynamic"
  tags = {
    Owner = var.owner
  }
}

resource "azurerm_network_interface" "jumpbox_nic" {
  name                         =  "${var.id}_jumpbox_nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.avi_resource_group.name
  network_security_group_id = azurerm_network_security_group.jumpbox_sg.id
  ip_configuration {
    name                         =  "${var.id}_jumpbox_ip"
    subnet_id                     =  azurerm_subnet.avi_pubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_eip.id
  }
  tags = {
    Owner = var.owner
  }
}

resource "azurerm_virtual_machine" "jumpbox" {
  name          = "${var.id}_jumpbox"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.avi_resource_group.name
  vm_size                   = var.flavour_centos
  network_interface_ids     = [ azurerm_network_interface.jumpbox_nic.id ]

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

# az vm image list --output table

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-RAW"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.id}_jumpbox_ssd"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
    #disk_size_gb      =  var.vol_size_centos
  }


  os_profile {
    computer_name   = "${var.id}-jumpbox"
    admin_username  = var.avi_backup_admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.avi_backup_admin_username}/.ssh/authorized_keys"
      key_data = "${trimspace(tls_private_key.generated_access_key.public_key_openssh)} aviadmin@avinetworks"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Owner                         = var.owner
    Lab_Group                     = "jumpbox"
    Lab_Name                      = "jumpbox.student.lab"
    Lab_vpc_id                    = azurerm_virtual_network.avi_vnet.id
    Lab_avi_default_password      = var.avi_default_password
    Lab_avi_admin_password        = var.avi_admin_password
    Lab_avi_backup_admin_username = var.avi_backup_admin_username
    Lab_avi_backup_admin_password = var.avi_backup_admin_password
    Lab_avi_management_network    = "${var.id}_management_network"
    Lab_avi_vip_network           = "${var.id}_VIP_network"
    Lab_Noshut                    = "jumpbox"
    Lab_Timezone                  = var.lab_timezone
  }
}

resource "azurerm_virtual_machine_extension" "jumpbox" {
  name                 = "${var.id}-jumpbox"
  location             = var.location
  resource_group_name  = azurerm_resource_group.avi_resource_group.name
  virtual_machine_name = azurerm_virtual_machine.jumpbox.name
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/smarunich/improved-goggles/master/provisioning/provision_jumpbox.sh"],
        "commandToExecute": "./provision_jumpbox.sh"
    }
SETTINGS

  tags = {
    Owner = var.owner
  }
}
