
resource "bigip_ltm_pool_attachment" "attach_node" {
  for_each = var.node_map
  pool     = bigip_ltm_pool.pool.name
  node     = "/${var.vip_partition}/${each.value.name}:${var.node_listen_port}"

  # how the node gets added to / updated in pool: enabled, disabled, forced_offline
  state = each.value.pool_state
}