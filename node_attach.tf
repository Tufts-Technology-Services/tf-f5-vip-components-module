
resource "bigip_ltm_pool_attachment" "attach_node" {
  for_each = var.node_map

  pool = bigip_ltm_pool.pool.name
  node = "${each.value.address}:${var.node_listen_port}"
}