resource "azurerm_resource_group" "resource_group" {
  name     = local.prefix
  location = var.location
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = local.prefix
  }
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  name                       = "${local.prefix}-${format("%.4s", uuid())}"
  resource_group_name        = azurerm_resource_group.resource_group.name
  location                   = var.location
  sku                        = "PerGB2018"
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = local.prefix
  }
  lifecycle {
    ignore_changes = [name, sku]
  }
}

resource "azurerm_storage_account" "storage_account" {
  account_replication_type = "LRS"
  name                     = format("%.24s", "${lower(var.client_code)}${lower(var.environment)}stgacct")
  resource_group_name      = azurerm_resource_group.resource_group.name
  account_tier             = "Standard"
  location                 = var.location
  access_tier              = "Hot"
  is_hns_enabled           = false
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = format("%.24s", "${lower(var.client_code)}${lower(var.environment)}stgacct")
  }
  account_kind = "StorageV2"
}