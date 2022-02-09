locals {
  prefix              = length(var.prefix) > 0 ? lower(var.prefix) : "${lower(var.client_code)}-${lower(var.environment)}-${lower(var.product)}"
  subnet_cidr_newbits = 2
  empty_subnet        = cidrsubnet(var.vnet_cidr, local.subnet_cidr_newbits, 3)
  keyvault_name       = format("%.24s", "${lower(var.client_code)}${lower(var.environment)}${format("%.4s", uuid())}")
}
