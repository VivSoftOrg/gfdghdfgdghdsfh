output "private_subnet_cidr" {
  value = azurerm_subnet.private_subnet.address_prefix
}
output "management_subnet_name" {
  value = azurerm_subnet.management_subnet.name
}
output "gateway_subnet_name" {
  value = azurerm_subnet.gateway_subnet.name
}
output "private_subnet_name" {
  value = azurerm_subnet.private_subnet.name
}
output "private_route_table_name" {
  value = azurerm_route_table.private_route_table.name
}
output "application_gateway_subnet_cidr" {
  value = azurerm_subnet.application_gateway_subnet.address_prefix
}
output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.id
}
output "application_gateway_subnet_id" {
  value = azurerm_subnet.application_gateway_subnet.id
}
output "public_subnet_cidr" {
  value = azurerm_subnet.public_subnet.address_prefix
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
output "management_subnet_id" {
  value = azurerm_subnet.management_subnet.id
}
output "private_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}
output "firewall_subnet_cidr" {
  value = azurerm_subnet.firewall_subnet.address_prefix
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "firewall_subnet_name" {
  value = azurerm_subnet.firewall_subnet.name
}
output "vnet_cidr" {
  value = azurerm_virtual_network.vnet.address_space.0
}
output "management_subnet_cidr" {
  value = azurerm_subnet.management_subnet.address_prefix
}
output "public_subnet_name" {
  value = azurerm_subnet.public_subnet.name
}
output "public_route_table_id" {
  value = azurerm_route_table.public_route_table.id
}
output "gateway_subnet_cidr" {
  value = azurerm_subnet.gateway_subnet.address_prefix
}
output "private_route_table_id" {
  value = azurerm_route_table.private_route_table.id
}
output "firewall_subnet_id" {
  value = azurerm_subnet.firewall_subnet.id
}
output "vnet_location" {
  value = azurerm_virtual_network.vnet.location
}
output "public_subnet_id" {
  value = azurerm_subnet.public_subnet.id
}
output "application_gateway_subnet_name" {
  value = azurerm_subnet.application_gateway_subnet.name
}
output "keyvault_managed_identity_id" {
  value = azurerm_user_assigned_identity.keyvault_managed_identity.id
}
output "keyvault_uri" {
  value = azurerm_key_vault.keyvault.vault_uri
}
output "resource_group_id" {
  value = azurerm_resource_group.resource_group.id
}
output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}
output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.storage_account.primary_blob_endpoint
}
output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}
output "keyvault_certificate_secret_id" {
  value = azurerm_key_vault_certificate.cert.secret_id
}
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.name
}
output "keyvault_certificate_name" {
  value = "${lower(var.client_code)}-${lower(var.environment)}-sslcert"
}
output "keyvault_certificate_id" {
  value = azurerm_key_vault_certificate.cert.id
}
output "keyvault_managed_identity_principal_id" {
  value = azurerm_user_assigned_identity.keyvault_managed_identity.principal_id
}
output "keyvault_name" {
  value = azurerm_key_vault.keyvault.name
}
output "resource_group_location" {
  value = azurerm_resource_group.resource_group.location
}
output "keyvault_id" {
  value = azurerm_key_vault.keyvault.id
}
output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}
output "rdp_remote_access_nsg_id" {
  value = azurerm_network_security_group.rdp-remote-access-nsg.id
}
output "bastion_scale_set_id" {
  value = join(",", azurerm_linux_virtual_machine_scale_set.bastion_scale_set.*.id)
}
output "ssh_remote_access_nsg_id" {
  value = azurerm_network_security_group.ssh-remote-access-nsg.id
}
output "winrm_remote_access_nsg" {
  value = azurerm_network_security_group.winrm-remote-access-nsg.id
}
output "https_remote_access_nsg_name" {
  value = azurerm_network_security_group.https-remote-access-nsg.name
}
output "https_remote_access_nsg_id" {
  value = azurerm_network_security_group.https-remote-access-nsg.id
}
output "bastion_private_key" {
  value = join(",", tls_private_key.bastion_ssh_key.*.private_key_pem)
}
output "nat_gateway_id" {
  value = azurerm_nat_gateway.nat_gateway.id
}
output "nat_public_ip" {
  value = azurerm_public_ip.nat_public_ip.ip_address
}
