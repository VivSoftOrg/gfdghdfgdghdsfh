resource "azurerm_key_vault" "keyvault" {
  name                            = local.keyvault_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.resource_group.name
  sku_name                        = "standard"
  enabled_for_disk_encryption     = false
  enable_rbac_authorization       = false
  enabled_for_deployment          = false
  tenant_id                       = data.azurerm_client_config.azurerm_client_config.tenant_id
  soft_delete_retention_days      = var.keyvault_soft_delete_retention_days
  enabled_for_template_deployment = false
  # soft_delete_enabled             = true # DEPRECATED
  access_policy {
    tenant_id               = data.azurerm_client_config.azurerm_client_config.tenant_id
    object_id               = data.azurerm_client_config.azurerm_client_config.object_id
    certificate_permissions = ["Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "SetIssuers", "Update", "Purge"]
    key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  }
  tags = {
    Name        = "${lower(var.client_code)}lower(var.environment)}"
    Environment = var.environment
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
  }
  lifecycle {
    ignore_changes = [name]
  }
}
resource "azurerm_user_assigned_identity" "keyvault_managed_identity" {
  name                = local.prefix
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  tags = {
    Name        = local.prefix
    Environment = var.environment
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
  }
}

resource "azurerm_key_vault_certificate" "cert" {
  name         = "${lower(var.client_code)}-${lower(var.environment)}-sslcert"
  key_vault_id = azurerm_key_vault.keyvault.id

  certificate {
    contents = filebase64("dummy_cert/_wildcard.example.pfx")
    password = var.certificate_password
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}
