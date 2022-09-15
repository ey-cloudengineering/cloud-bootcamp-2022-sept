provider "azurerm" {
  features {}
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "<Your Initials-XX>-c101-lab-1b-vm"
  resource_group_name             = "<LAB 1A RESOURCE GROUP NAME>"
  location                        = "<LAB 1A AZURE REGION CODE>"
  size                            = "Standard_DS1_v2"
  admin_username                  = "<LAB 1A WINDOWS LOGIN NAME>"
  admin_password                  = "<LAB 1A WINDOWS PASSWORD"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "<Your Initials-XX>-c101-lab-1b-nic"
  location            = "<LAB 1A AZURE REGION CODE>"
  resource_group_name = "<LAB 1A RESOURCE GROUP NAME>"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "<handout subnet id>"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "data" {
  name                 = "<Your Initials-XX>-c101-lab-1b-data"
  location             = "<LAB 1A AZURE REGION CODE>"
  create_option        = "Empty"
  disk_size_gb         = 10
  resource_group_name  = "<LAB 1A RESOURCE GROUP NAME>"
  storage_account_type = "Standard_LRS"
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  managed_disk_id    = azurerm_managed_disk.data.id
  lun                = 0
  caching            = "None"
}
