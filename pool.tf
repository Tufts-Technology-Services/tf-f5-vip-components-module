
resource "bigip_ltm_pool" "pool" {
  name                   = "/${var.vip_partition}/tf-${var.pool_name}-${var.node_listen_port}"
  load_balancing_mode    = "${var.pool_load_balancing_mode}"
  minimum_active_members = var.pool_minimum_active_members
  # monitors               = [bigip_ltm_monitor.monitor.name]
}