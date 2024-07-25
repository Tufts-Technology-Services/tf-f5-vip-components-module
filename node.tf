resource "bigip_ltm_node" "node" {
  for_each = var.node_map
  
  name             = "/${var.vip_partition}/${each.value.address}"
  address          = "${each.value.address}"
  connection_limit = "0"
  dynamic_ratio    = "1"
  monitor          = "/Common/icmp"
  description      = "${each.value.description}"
  rate_limit       = "disabled"

  # note necessary and tufts doesn't seem to create nodes this way anyways
  # fqdn {
  #   address_family = "ipv4"
  #   interval       = "3600" # seems to be the default of our tab test f5
  # }
}