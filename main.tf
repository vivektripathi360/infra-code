resource "azurerm_resource_group" "rg5" {
  name     = "rg6"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet5" {
  name                = "vnet6"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg5.location
  resource_group_name = azurerm_resource_group.rg5.name
}

resource "azurerm_subnet" "subnet5" {
  name                 = "subnet6"
  resource_group_name  = azurerm_resource_group.rg5.name
  virtual_network_name = azurerm_virtual_network.vnet5.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic5" {
  name                = "nic6"
  location            = azurerm_resource_group.rg5.location
  resource_group_name = azurerm_resource_group.rg5.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet5.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_public_ip" "public_ip" {
  name                = "ip"
  location            = azurerm_resource_group.rg5.location
  resource_group_name = azurerm_resource_group.rg5.name
  allocation_method   = "static"

}


resource "azurerm_linux_virtual_machine" "vm5" {
  name                = "vm6"
  resource_group_name = azurerm_resource_group.rg5.name
  location            = azurerm_resource_group.rg5.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "monti@123456"
  network_interface_ids = [
    azurerm_network_interface.example.id,
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
}
