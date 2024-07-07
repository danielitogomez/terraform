terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.53.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

data "azurerm_resource_group" "multicloud_poc" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "multicloud_poc" {
  name                = "multicloud_poc-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.multicloud_poc.location
  resource_group_name = data.azurerm_resource_group.multicloud_poc.name
}

resource "azurerm_subnet" "multicloud_poc" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.multicloud_poc.name
  virtual_network_name = azurerm_virtual_network.multicloud_poc.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vm_public_ip"
  resource_group_name = data.azurerm_resource_group.multicloud_poc.name
  location            = data.azurerm_resource_group.multicloud_poc.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "multicloud_poc" {
  name                = "multicloud_poc-nic"
  location            = data.azurerm_resource_group.multicloud_poc.location
  resource_group_name = data.azurerm_resource_group.multicloud_poc.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.multicloud_poc.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "ssh_nsg"
  location            = data.azurerm_resource_group.multicloud_poc.location
  resource_group_name = data.azurerm_resource_group.multicloud_poc.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.multicloud_poc.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "multicloud_poc_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "multicloud_poc" {
  name                = "multicloud-poc-machine"
  resource_group_name = data.azurerm_resource_group.multicloud_poc.name
  location            = data.azurerm_resource_group.multicloud_poc.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.multicloud_poc.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.multicloud_poc_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "multicloud_poc_vm_extension" {
  name                 = "init-script"
  virtual_machine_id   = azurerm_linux_virtual_machine.multicloud_poc.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = jsonencode({
    "commandToExecute" = "sudo apt-get update && sudo apt-get install -y apache2"
  })
}