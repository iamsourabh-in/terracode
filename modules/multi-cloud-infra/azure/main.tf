resource "azurerm_resource_group" "multi_cloud_azure_resource_group" {
  name     = "example-resources"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "multi_cloud_azure_virtual_network" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.multi_cloud_azure_resource_group.name
  location            = azurerm_resource_group.multi_cloud_azure_resource_group.location
  address_space       = ["10.0.0.0/16"]
}