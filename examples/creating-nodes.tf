locals {
  UNIQUENAME_vip_partition = "mypartition"

  # this structure is passed into the module and also 
  # reused for node creation outside of the module
  UNIQUENAME_node_map = {
    # the keys in this dictionary (e.g. "01", "02" etc) are not used for anything.
    # you may use anything you like for the keys, as long as they're unique.
    "01" = {
      name        = "tf-hostname1.example.com", # yes use "tf-" prefix here
      description = "hostname1.example.com",    # no "tf-" prefix here. It's added automatically in the `_node` declaration down below
      address     = "a.b.c.d",

      # this controls how the node is added/updated to the pool:
      # enabled, disabled, forced_offline
      pool_state = "enabled",
    },
    "02" = {
      name        = "hostname2.example.com",
      description = "host 2",
      address     = "a.b.c.e",
      pool_state  = "enabled",
    },
  }
}

/* 
Note that creating the nodes themselves happens outside the module to 
allow for flexibility and for nodes participating in >1 pool.
*/

# now let's create our nodes based on the structure  
resource "bigip_ltm_node" "UNIQUENAME_node" {
  for_each = local.UNIQUENAME_node_map

  name             = "/${local.UNIQUENAME_vip_partition}/${each.value.name}"
  address          = each.value.address
  connection_limit = "0"
  dynamic_ratio    = "1"

  # it's recommended to add some sort of signifier so that others will know 
  # this node is managed via terraform, thus the tf- here in the description
  description = "tf-${each.value.description}"
  rate_limit  = "disabled"
}