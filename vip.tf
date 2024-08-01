
resource "bigip_ltm_virtual_server" "vip" {
  name                       = "/${var.vip_partition}/${var.vip_name}-${var.vip_port}"
  destination                = var.vip_destination_ip
  description                = "tf-${var.vip_description}"
  port                       = var.vip_port
  pool                       = bigip_ltm_pool.pool.name
  client_profiles            = var.vip_client_profiles_list
  server_profiles            = var.vip_server_profiles_list
  profiles                   = var.vip_profiles_list
  security_log_profiles      = var.vip_sec_log_profiles_list
  source_address_translation = var.vip_source_address_translation
  vlans_enabled              = true
  vlans                      = var.vip_enabled_vlans
  irules                     = var.vip_irule_list
}