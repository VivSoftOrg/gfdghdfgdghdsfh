resource "azurerm_nat_gateway" "nat_gateway" {
  idle_timeout_in_minutes = "4"
  name                    = local.prefix
  resource_group_name     = azurerm_resource_group.resource_group.name
  location                = var.location
  sku_name                = "Standard"
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-nat"
  }
}

resource "azurerm_public_ip" "nat_public_ip" {
  allocation_method   = "Static"
  ip_version          = "IPv4"
  name                = "${local.prefix}-nat"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  sku                 = "Standard"
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-nat"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_gateway_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.application_gateway_subnet.id
  network_security_group_id = azurerm_network_security_group.https-remote-access-nsg.id
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  lifecycle {
    create_before_destroy = false
  }
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_to_management_subnet_association" {
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
  subnet_id      = azurerm_subnet.management_subnet.id
}
resource "azurerm_subnet_nat_gateway_association" "nat_to_private_subnet_association" {
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
  subnet_id      = azurerm_subnet.private_subnet.id
}

resource "azurerm_subnet_route_table_association" "public_route_association" {
  route_table_id = element(azurerm_route_table.public_route_table.*.id, 0)
  subnet_id      = element(azurerm_subnet.public_subnet.*.id, 0)
}
resource "azurerm_subnet_route_table_association" "private_route_association" {
  route_table_id = element(azurerm_route_table.private_route_table.*.id, 0)
  subnet_id      = element(azurerm_subnet.private_subnet.*.id, 0)
}
resource "azurerm_subnet_route_table_association" "management_route_association" {
  route_table_id = element(azurerm_route_table.private_route_table.*.id, 0)
  subnet_id      = element(azurerm_subnet.management_subnet.*.id, 0)
}