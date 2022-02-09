variable "owner" {
  type    = string
  default = "Unknown"
}
variable "environment" {
  type    = string
  default = "prod"
}
variable "product" {
  type    = string
  default = "landing-zone"
}
// variable "certificate_data" {
//   type    = string
//   default = null
// }
variable "keyvault_soft_delete_retention_days" {
  type    = number
  default = 90
}
variable "prefix" {
  type    = string
  default = ""
}
variable "project" {
  type    = string
  default = "lz"
}
variable "certificate_password" {
  type    = string
  default = "dummyCert123"
}
variable "location" {
  type    = string
  default = "eastus"
}
variable "client_code" {
  type    = string
  default = null
}

variable "remote_admin" {
  type    = string
  default = "transit"
}
variable "vnet_cidr" {
  type = string
}
variable "remote_admin_ips" {
  type    = list(any)
  default = []
}
variable "bastion_scale_set_capacity" {
  type    = number
  default = 1
}
variable "vdss_transit_vpc_cidr" {
  type    = string
  default = ""
}
variable "vpn_remote_cidr_block" {
  type    = string
  default = ""
}
variable "bastion_user" {
  type    = string
  default = "ubuntu"
}
variable "public_subnet_id" {
  type    = string
  default = ""
}
variable "vdms_vpc_cidr" {
  type    = string
  default = ""
}
variable "private_subnet_service_endpoints" {
  type    = string
  default = ""
}
variable "disable_private_endpoint_network_policies" {
  type    = bool
  default = false
}
