module "UNIQUENAME-vip-80" {
  source = "github.com/Tufts-Technology-Services/tf-f5-vip-components-module?ref=v0.0.7"

  # the vip_port will automatically get appended to the vip_name
  vip_name           = "UNIQUENAME-vip"
  vip_destination_ip = "w.x.y.z"

  # "tf-" will automatically be prepended to the vip description
  vip_description = "UNIQUENAME"
  vip_port        = 80
  vip_partition   = local.UNIQUENAME_vip_partition

  # To find what VLAN you will listen on, go to Network > Self IPs. Find the F5 IP
  # that is on the same subnet as your destination IP, and look at the "VLAN / Tunnel"
  vip_enabled_vlans = ["/Common/someVLAN"]

  # node_listen_port will automatically get appended to the pool_name
  pool_name          = "pool-UNIQUENAME-tf"
  pool_description   = "pool-UNIQUENAME-tf"
  pool_monitors_list = ["/Common/tcp"]

  node_listen_port = 80
  node_map         = local.UNIQUENAME_node_map
}