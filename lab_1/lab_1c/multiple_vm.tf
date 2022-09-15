provider "azurerm" {
  features {}
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.name}-${count.index}-lab-1c"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  count                           = var.number_of_vm
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.*.id[count.index],
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
  count               = var.number_of_vm
  name                = "${var.name}-${count.index}-lab-1c-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "data" {
  count               = var.number_of_vm
  name                 = "${var.name}-${count.index}-lab-1c-data"
  location             = var.location
  create_option        = "Empty"
  disk_size_gb         = 10
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  count              = var.number_of_vm
  virtual_machine_id = azurerm_linux_virtual_machine.main.*.id[count.index]
  managed_disk_id    = azurerm_managed_disk.data.*.id[count.index]
  lun                = 0
  caching            = "None"
}
