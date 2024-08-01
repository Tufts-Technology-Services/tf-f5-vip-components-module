# tf-f5-vip-components-module

## Usage

See below for examples.  Most input variables make an attempt at setting a "sane and reasonable" default but can be overridden if desired.  For the list of input variables and their requirements/defaults, see: [./variables.tf](variables.tf)

If you don't see a variable for something that you need, it's probably either:

1. it just hasn't been added to the module yet; feel free to open an issue to discuss; or,
1. it's something that just isn't straightforward at all or doesn't align with the web UI; try looking at [.properties.md](properties.md) to see if it's documented there

Note that creating the nodes themselves happens outside the module to allow for flexibility and for nodes participating in >1 pool.

Here's an example:

```hcl
locals {
  vip_partition = "mypartition"
  
  # this structure is passed into the module and also 
  # reused for node creation outside of the module
  node_map_main = {
    # this key currently isn't used in the module, but might be at a future date.
    # any value will work here, as long as they're unique.
    "01" = {
      name        = "hostname1.example.com",
      description = "host 1",
      address     = "a.b.c.d",

      # this controls how the node is added/updated to the pool:
      # enabled, disabled, forced_offline
      pool_state  = "enabled",
    },
    "02" = {
      name        = "hostname2.example.com",
      description = "host 2",
      address     = "a.b.c.e",
      pool_state  = "enabled",
    },
  }
}

# now let's create our nodes based on the structure  
resource "bigip_ltm_node" "node" {
  for_each = local.node_map_main
  
  name             = "/${local.vip_partition}/${each.value.name}"
  address          = "${each.value.address}"
  connection_limit = "0"
  dynamic_ratio    = "1"
  monitor          = "/Common/icmp"

  # it's recommended to add some sort of signifier so that others will know 
  # this node is managed via terraform, thus the tf- here in the description
  description      = "tf-${each.value.description}"
  rate_limit       = "disabled"
}
```

Now let's create the actual VIP, pool, and handle attaching the nodes to the pool via a "bare minimum" example:

```hcl
module "test-vip" {
  source            = "github.com/Tufts-Technology-Services/tf-f5-vip-components-module?ref=v0.0.5"

  # the vip_port will automatically get appended to the vip_name
  vip_name           = "test-vip"
  vip_destination_ip = "w.x.y.z"

  # "tf-" will automatically be prepended to the vip description
  vip_description    = "my vip"
  vip_port           = 80
  vip_partition      = local.vip_partition
  vip_enabled_vlans = ["/mypartition/someVLAN"]

  # node_listen_port will automatically get appended to the pool_name
  pool_name          = "pool-test-tf"
  pool_description   = "pool-test-tf"

  node_listen_port   = 80
  node_map           = local.node_map_main
}  
```

## Known issues

On `terraform destroy`, sometimes the provider has a slight race condition when removing everything, and you might see an error like the following:

> │ Error: 01070110:3: Node address '/somepartition/my-node-name' is referenced by a member of pool '/somepartition/my-pool-name-80'.

even though that's the exact stuff you're trying to `destroy`. Running another `terraform destroy` will finish the teardown.

A similar issue can happen on `terraform apply`, where you're creating X and Y, where Y depends on X, and you'll get a failure:

> Error: 01020036:3: The requested Node (/Enterprise/smtpout-prod-05.uit.tufts.edu) was not found.

and same thing where if you apply it a second time, it'll sort itself out.

Unfortunately, TF is subject to the whims and flaws of the vendor API on the device.  TBD if setting some kind of delay/repeat or an explicit `depends-on` relationship will improve this.
