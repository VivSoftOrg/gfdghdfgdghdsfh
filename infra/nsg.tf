resource "azurerm_network_security_group" "https-remote-access-nsg" {
  name                = "${local.prefix}-https"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-https"
  }
}
resource "azurerm_network_security_group" "rdp-remote-access-nsg" {
  name                = "${local.prefix}-rdp"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-rdp"
  }
}
resource "azurerm_network_security_group" "ssh-remote-access-nsg" {
  name                = "${local.prefix}-ssh"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-ssh"
  }
}
resource "azurerm_network_security_group" "winrm-remote-access-nsg" {
  name                = "${local.prefix}-winrm"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-winrm"
  }
}

resource "azurerm_network_security_rule" "https-rules-vpn" {
  count                       = var.remote_admin == "transit" ? 1 : 0
  protocol                    = "Tcp"
  destination_port_range      = "443"
  access                      = "Allow"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.https-remote-access-nsg.name
  name                        = "${local.prefix}-https-rules-vpn"
  source_address_prefixes     = flatten([compact(concat(tolist([var.vnet_cidr, var.vdms_vpc_cidr, var.vdss_transit_vpc_cidr]), split(",", var.vpn_remote_cidr_block)))])
  resource_group_name         = azurerm_resource_group.resource_group.name
  destination_address_prefix  = "*"
  priority                    = "100"
  direction                   = "Inbound"
}
resource "azurerm_network_security_rule" "rdp-rules-remote-ips" {
  count                       = var.remote_admin == "bastion" && length(var.remote_admin_ips) > 0 ? 1 : 0
  protocol                    = "Tcp"
  destination_port_range      = "3389"
  access                      = "Allow"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.rdp-remote-access-nsg.name
  name                        = "${local.prefix}-rdp-rules-remote-ips"
  source_address_prefixes     = flatten([var.remote_admin_ips])
  resource_group_name         = azurerm_resource_group.resource_group.name
  destination_address_prefix  = "*"
  priority                    = "100"
  direction                   = "Inbound"
}
resource "azurerm_network_security_rule" "winrm-rules-remote-ips" {
  count                       = var.remote_admin == "bastion" && length(var.remote_admin_ips) > 0 ? 1 : 0
  protocol                    = "Tcp"
  destination_port_range      = "5986"
  access                      = "Allow"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.winrm-remote-access-nsg.name
  name                        = "${local.prefix}-winrm-rules-remote-ips"
  source_address_prefixes     = flatten([var.remote_admin_ips])
  resource_group_name         = azurerm_resource_group.resource_group.name
  destination_address_prefix  = "*"
  priority                    = "100"
  direction                   = "Inbound"
}
resource "azurerm_network_security_rule" "https-rules-remote-ips" {
  count                       = var.remote_admin == "bastion" && length(var.remote_admin_ips) > 0 ? 1 : 0
  protocol                    = "Tcp"
  destination_port_range      = "443"
  access                      = "Allow"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.https-remote-access-nsg.name
  name                        = "${local.prefix}-https-rules-remote-ips"
  source_address_prefixes     = flatten([var.remote_admin_ips])
  resource_group_name         = azurerm_resource_group.resource_group.name
  destination_address_prefix  = "*"
  priority                    = "100"
  direction                   = "Inbound"
}
resource "azurerm_network_security_rule" "rdp-rules-vpn" {
  count                       = var.remote_admin == "transit" ? 1 : 0
  protocol                    = "Tcp"
  destination_port_range      = "3389"
  access                      = "Allow"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.rdp-remote-access-nsg.name
  name                        = "${local.prefix}-rdp-rules-vpn"
  source_address_prefixes     = flatten([compact(concat(tolist([var.vnet_cidr, var.vdms_vpc_cidr, var.vdss_transit_vpc_cidr]), split(",", var.vpn_remote_cidr_block)))])
  resource_group_name         = azurerm_resource_group.resource_group.name
  destination_address_prefix  = "*"
  priority                    = "100"
  direction                   = "Inbound"
}
resource "azurerm_network_security_rule" "ssh-rules-remote-ips" {
  count                       = var.remote_admin == "bastion" && length(var.remote_admin_ips) > 0 ? 1 : 0
  protocol                    = "Tcp"
  destination_port_range      = "22"
  access                      = "Allow"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.ssh-remote-access-nsg.name
  name                        = "${local.prefix}-ssh-rules-remote-ips"
  source_address_prefixes     = flatten([var.remote_admin_ips])
  resource_group_name         = azurerm_resource_group.resource_group.name
  destination_address_prefix  = "*"
  priority                    = "100"
  direction                   = "Inbound"
}
resource "azurerm_network_security_rule" "ssh-rules-vpn" {
  count                       = var.remote_admin == "transit" ? 1 : 0
  protocol                    = "Tcp"
  destination_port_range      = "22"
  access                      = "Allow"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.ssh-remote-access-nsg.name
  name                        = "${local.prefix}-ssh-rules-vpn"
  source_address_prefixes     = flatten([compact(concat(tolist([var.vnet_cidr, var.vdms_vpc_cidr, var.vdss_transit_vpc_cidr]), split(",", var.vpn_remote_cidr_block)))])
  resource_group_name         = azurerm_resource_group.resource_group.name
  destination_address_prefix  = "*"
  priority                    = "100"
  direction                   = "Inbound"
}
resource "azurerm_network_security_rule" "gateway_manager_rule" {
  protocol                    = "Tcp"
  access                      = "Allow"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  network_security_group_name = azurerm_network_security_group.https-remote-access-nsg.name
  name                        = "${local.prefix}-gateway-manager-rule"
  resource_group_name         = azurerm_resource_group.resource_group.name
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  priority                    = "1000"
  direction                   = "Inbound"
}
resource "azurerm_network_security_rule" "winrm-rules-vpn" {
  count                       = var.remote_admin == "transit" ? 1 : 0
  protocol                    = "Tcp"
  destination_port_range      = "5986"
  access                      = "Allow"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.winrm-remote-access-nsg.name
  name                        = "${local.prefix}-winrm-rules-vpn"
  source_address_prefixes     = flatten([compact(concat(tolist([var.vnet_cidr, var.vdms_vpc_cidr, var.vdss_transit_vpc_cidr]), split(",", var.vpn_remote_cidr_block)))])
  resource_group_name         = azurerm_resource_group.resource_group.name
  destination_address_prefix  = "*"
  priority                    = "100"
  direction                   = "Inbound"
}
