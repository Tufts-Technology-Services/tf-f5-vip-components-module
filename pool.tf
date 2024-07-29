
resource "bigip_ltm_pool" "pool" {
  name                   = "/${var.vip_partition}/${var.pool_name}-${var.node_listen_port}"
  load_balancing_mode    = var.pool_load_balancing_mode
  description            = "tf-${var.pool_description}"
  minimum_active_members = var.pool_minimum_active_members
  monitors               = var.pool_monitors_list
}