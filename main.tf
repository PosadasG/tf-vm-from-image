# 1. Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.1"
    }
  }
}
# 2. Configure the AzureRM Provider
provider "azurerm" {
  features {}
}


#3. Create Network  Interface
resource "azurerm_resource_group" "main" {
  name     = "DevOps-vm-eastus-gr2"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name                = "DevOps-vm-eastus_group-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "eastus-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}


#Create Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = "buildtools-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_D2as_v5"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    id  = "/subscriptions/889e0d33-260f-4ecf-8169-80c94ab06dd8/resourceGroups/DevOps-vm-eastus_group/providers/Microsoft.Compute/galleries/DevOps.eastus.gl/images/EastUS-BT2022-img-df"
  }

   storage_os_disk {
    name          = "buildtools"
    caching       = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "buildtools"
    admin_username = "devops-admin"
    admin_password = "Pa$$w0rd1234"
  }
  os_profile_windows_config {
     provision_vm_agent = true
  }
  tags = {
    environment = "staging"
  }
}