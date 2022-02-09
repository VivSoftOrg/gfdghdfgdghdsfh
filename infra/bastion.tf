resource "tls_private_key" "bastion_ssh_key" {
  count       = var.remote_admin == "bastion" ? 1 : 0
  ecdsa_curve = "P224"
  rsa_bits    = "2048"
  algorithm   = "RSA"
}

resource "azurerm_linux_virtual_machine_scale_set" "bastion_scale_set" {
  count                                             = var.remote_admin == "bastion" ? 1 : 0
  scale_in_policy                                   = "Default"
  zone_balance                                      = false
  do_not_run_extensions_on_overprovisioned_machines = false
  name                                              = "${local.prefix}-bastion-scale-set"
  provision_vm_agent                                = true
  computer_name_prefix                              = local.prefix
  location                                          = var.location
  sku                                               = "Standard_B1ms"
  single_placement_group                            = true
  lifecycle {
    create_before_destroy = false
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  admin_username                  = var.bastion_user
  instances                       = var.bastion_scale_set_capacity
  overprovision                   = true
  disable_password_authentication = true
  resource_group_name             = azurerm_resource_group.resource_group.name
  admin_ssh_key {
    public_key = tls_private_key.bastion_ssh_key[0].public_key_openssh
    username   = var.bastion_user
  }
  upgrade_mode  = "Manual"
  max_bid_price = "-1"
  priority      = "Regular"
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  network_interface {
    name                      = "${local.prefix}-network-profile"
    network_security_group_id = azurerm_network_security_group.ssh-remote-access-nsg.id
    primary                   = true
    ip_configuration {
      name      = "${local.prefix}-ip-configuration"
      primary   = true
      subnet_id = var.public_subnet_id
      version   = "IPv4"
      public_ip_address {
        domain_name_label       = "${lower(var.client_code)}-${lower(var.environment)}-bastion"
        idle_timeout_in_minutes = "4"
        name                    = "${local.prefix}-bastion-ip"
      }
    }
  }
  tags = {
    Owner       = var.owner
    Product     = var.product
    Project     = var.project
    Environment = var.environment
    Name        = "${local.prefix}-bastion"
  }

}