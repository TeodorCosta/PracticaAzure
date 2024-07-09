resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "myVM${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"

  admin_username      = "adminuser"
  admin_password      = random_password.password.result

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
   custom_data = base64encode(<<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y inetutils-ping
  EOT
  )

  disable_password_authentication = false
}
