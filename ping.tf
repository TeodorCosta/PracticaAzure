resource "null_resource" "ping_test" {
  triggers = {
    vm1_ip = azurerm_public_ip.pip[0].ip_address
    vm2_ip = azurerm_public_ip.pip[1].ip_address
    vm3_ip = azurerm_public_ip.pip[2].ip_address
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.pip[0].ip_address
      user     = azurerm_linux_virtual_machine.vm[1].admin_username
      password = random_password.password.result
    }

    inline = [
      "ping -c 4 ${azurerm_public_ip.pip[1].ip_address}"
    ]
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.pip[1].ip_address
      user     = azurerm_linux_virtual_machine.vm[2].admin_username
      password = random_password.password.result
    }

    inline = [
      "ping -c 4 ${azurerm_public_ip.pip[2].ip_address}"
    ]
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.pip[2].ip_address
      user     = azurerm_linux_virtual_machine.vm[0].admin_username
      password = random_password.password.result
    }

    inline = [
      "ping -c 4 ${azurerm_public_ip.pip[0].ip_address}"
    ]
  }
}
