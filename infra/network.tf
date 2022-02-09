resource "azurerm_virtual_network" "vnet" {
  address_space       = flatten([var.vnet_cidr])
  name                = "${local.prefix}-vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-vnet"
  }
}

resource "azurerm_subnet" "public_subnet" {
  enforce_private_link_service_network_policies  = false
  enforce_private_link_endpoint_network_policies = false
  address_prefixes                               = flatten([cidrsubnet(var.vnet_cidr, local.subnet_cidr_newbits, 0)])
  name                                           = "${local.prefix}-public-subnet"
  resource_group_name                            = azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
}
resource "azurerm_subnet" "management_subnet" {
  enforce_private_link_service_network_policies  = false
  enforce_private_link_endpoint_network_policies = false
  address_prefixes                               = flatten([cidrsubnet(var.vnet_cidr, local.subnet_cidr_newbits, 2)])
  name                                           = "${local.prefix}-management_subnet"
  resource_group_name                            = azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
}
resource "azurerm_subnet" "gateway_subnet" {
  enforce_private_link_service_network_policies  = false
  enforce_private_link_endpoint_network_policies = false
  address_prefixes                               = flatten([cidrsubnet(local.empty_subnet, local.subnet_cidr_newbits, 2)])
  name                                           = "GatewaySubnet"
  resource_group_name                            = azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
}
resource "azurerm_subnet" "firewall_subnet" {
  enforce_private_link_service_network_policies  = false
  enforce_private_link_endpoint_network_policies = false
  address_prefixes                               = flatten([cidrsubnet(local.empty_subnet, local.subnet_cidr_newbits, 1)])
  name                                           = "AzureFirewallSubnet"
  resource_group_name                            = azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
}
resource "azurerm_subnet" "private_subnet" {
  enforce_private_link_service_network_policies  = false
  service_endpoints                              = flatten([split(",", var.private_subnet_service_endpoints)])
  enforce_private_link_endpoint_network_policies = var.disable_private_endpoint_network_policies
  address_prefixes                               = flatten([cidrsubnet(var.vnet_cidr, local.subnet_cidr_newbits, 1)])
  name                                           = "${local.prefix}-private_subnet"
  resource_group_name                            = azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
}
resource "azurerm_subnet" "application_gateway_subnet" {
  enforce_private_link_service_network_policies  = false
  enforce_private_link_endpoint_network_policies = false
  address_prefixes                               = flatten([cidrsubnet(local.empty_subnet, local.subnet_cidr_newbits, 0)])
  name                                           = "${local.prefix}-application_gateway_subnet"
  resource_group_name                            = azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
}

resource "azurerm_route_table" "public_route_table" {
  disable_bgp_route_propagation = false
  name                          = "${local.prefix}-public-route-table"
  resource_group_name           = azurerm_resource_group.resource_group.name
  location                      = var.location
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-public-route-table"
  }
}
resource "azurerm_route_table" "private_route_table" {
  disable_bgp_route_propagation = false
  name                          = "${local.prefix}-private-route-table"
  resource_group_name           = azurerm_resource_group.resource_group.name
  location                      = var.location
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-private-route-table"
  }
}