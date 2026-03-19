# tf-f5-vip-components-module

This repository consists of a Terraform module intended for use for automating the creation of virtual servers in the on-prem F5 load-balancers. The following links provide more information:

- [F5 automation](https://tuftswork.atlassian.net/wiki/spaces/EnterpriseSystems/pages/1224114177/F5+automation) documents the overall project and the various parts of it
- [github repository search](https://github.com/orgs/Tufts-Technology-Services/repositories?q=props.Components%3Af5) shows all of the instances where this is being used and is where things actually get created/managed.  Note that this relies on [github-custom-repo-properties](https://github.com/Tufts-Technology-Services/github-custom-repo-properties) being set on the repositories in order to show up in that search

## Usage

See below for examples.  Most input variables make an attempt at setting a "sane and reasonable" default but can be overridden if desired.  If you want to override a default, you can pass a new value instead, or, if you don't have a replacement value but still want to remove the default that would otherwise be applied, you can pass `null` as a value.

For the list of input variables and their requirements/defaults, see below in this readme.

If you don't see a variable for something that you need, it's probably either:

1. it just hasn't been added to the module yet; feel free to open an issue to discuss; or,
1. it's something that just isn't straightforward at all or doesn't align with the web UI; try looking at [.properties.md](properties.md) to see if it's documented there

## Examples

The [examples](./examples/) folder has example code with comments that can be copy-pasted, including:

- How to create nodes: [creating-nodes.tf](./examples/creating-nodes.tf)
  - Note that creating the nodes themselves happens outside the module to allow for flexibility and for nodes participating in >1 pool. Since we need to build a data structure that includes the node info anyways, we can take advantage of that structure to also build the nodes via a loop.
- a basic, minimal VIP: [basic-vip.tf](./examples/basic-vip.tf)

Note that many of the module parameters have defaults set so that it's not always necessary to specify every parameter.  For the list of parameters, whether they're optional or required, and what the defaults are, if any, see the section below.

<!-- markdownlint-disable MD033 MD060 -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_bigip"></a> [bigip](#requirement\_bigip) | >= 1.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_bigip"></a> [bigip](#provider\_bigip) | >= 1.22.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [bigip_ltm_pool.pool](https://registry.terraform.io/providers/F5Networks/bigip/latest/docs/resources/ltm_pool) | resource |
| [bigip_ltm_pool_attachment.attach_node](https://registry.terraform.io/providers/F5Networks/bigip/latest/docs/resources/ltm_pool_attachment) | resource |
| [bigip_ltm_virtual_server.vip](https://registry.terraform.io/providers/F5Networks/bigip/latest/docs/resources/ltm_virtual_server) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_node_listen_port"></a> [node\_listen\_port](#input\_node\_listen\_port) | the port that the nodes will listen on. Can be different than vip\_port. | `number` | n/a | yes |
| <a name="input_node_map"></a> [node\_map](#input\_node\_map) | object containing the nodes to add to the pool | <pre>map(object({<br/>    name        = string,<br/>    description = string,<br/>    address     = string,<br/>    pool_state  = string,<br/>  }))</pre> | `{}` | no |
| <a name="input_pool_description"></a> [pool\_description](#input\_pool\_description) | name of the pool, automatically gets tf- prepended | `string` | n/a | yes |
| <a name="input_pool_load_balancing_mode"></a> [pool\_load\_balancing\_mode](#input\_pool\_load\_balancing\_mode) | Load balancing mode. Valid values listed in properties.md file. | `string` | `"round-robin"` | no |
| <a name="input_pool_minimum_active_members"></a> [pool\_minimum\_active\_members](#input\_pool\_minimum\_active\_members) | n/a | `number` | `1` | no |
| <a name="input_pool_monitors_list"></a> [pool\_monitors\_list](#input\_pool\_monitors\_list) | List of monitor names to associate with the pool | `list(string)` | `[]` | no |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | name of the pool, node\_listen\_port gets automatically appended | `string` | n/a | yes |
| <a name="input_vip_client_profiles_list"></a> [vip\_client\_profiles\_list](#input\_vip\_client\_profiles\_list) | list of profiles, including partition | `list(string)` | <pre>[<br/>  "/Common/clientssl"<br/>]</pre> | no |
| <a name="input_vip_description"></a> [vip\_description](#input\_vip\_description) | vip description (ticket, owner, etc), automatically gets tf- appended | `string` | n/a | yes |
| <a name="input_vip_destination_ip"></a> [vip\_destination\_ip](#input\_vip\_destination\_ip) | target IP that the VIP will listen on | `string` | n/a | yes |
| <a name="input_vip_enabled_vlans"></a> [vip\_enabled\_vlans](#input\_vip\_enabled\_vlans) | list of vlans, including partition, on which to enable traffic for VIP listener | `list(string)` | n/a | yes |
| <a name="input_vip_irule_list"></a> [vip\_irule\_list](#input\_vip\_irule\_list) | list of irules, including partition | `list(string)` | <pre>[<br/>  "/Common/Drop-Non-Tufts-Connections"<br/>]</pre> | no |
| <a name="input_vip_name"></a> [vip\_name](#input\_vip\_name) | the name of the VIP/virtual server | `string` | n/a | yes |
| <a name="input_vip_partition"></a> [vip\_partition](#input\_vip\_partition) | the partition/namespace inside the F5 device where the VIP lives | `string` | n/a | yes |
| <a name="input_vip_persistence_profiles"></a> [vip\_persistence\_profiles](#input\_vip\_persistence\_profiles) | list of profiles, including partition | `list(string)` | <pre>[<br/>  "/Common/source_addr"<br/>]</pre> | no |
| <a name="input_vip_port"></a> [vip\_port](#input\_vip\_port) | the port that the VIP listens on | `number` | n/a | yes |
| <a name="input_vip_profiles_list"></a> [vip\_profiles\_list](#input\_vip\_profiles\_list) | These get applied to both client and server. list of profiles, including partition | `list(string)` | <pre>[<br/>  "/Common/tcp"<br/>]</pre> | no |
| <a name="input_vip_sec_log_profiles_list"></a> [vip\_sec\_log\_profiles\_list](#input\_vip\_sec\_log\_profiles\_list) | list of profiles, including partition | `list(string)` | <pre>[<br/>  "/Common/global-network"<br/>]</pre> | no |
| <a name="input_vip_server_profiles_list"></a> [vip\_server\_profiles\_list](#input\_vip\_server\_profiles\_list) | list of profiles, including partition | `list(string)` | <pre>[<br/>  "/Common/serverssl"<br/>]</pre> | no |
| <a name="input_vip_source_address_translation"></a> [vip\_source\_address\_translation](#input\_vip\_source\_address\_translation) | the type of translatio to be used, if any. snat, automap, none | `string` | `"automap"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Known issues

### Race conditions

On `terraform destroy`, sometimes the provider has a slight race condition when removing everything, and you might see an error like the following:

> │ Error: 01070110:3: Node address '/somepartition/my-node-name' is referenced by a member of pool '/somepartition/my-pool-name-80'.

even though that's the exact stuff you're trying to `destroy`. Running another `terraform destroy` will finish the teardown.

A similar issue can happen on `terraform apply`, where you're creating X and Y, where Y depends on X, and you'll get a failure:

> Error: 01020036:3: The requested Node (/Enterprise/smtpout-prod-05.uit.tufts.edu) was not found.

and same thing where if you apply it a second time, it'll sort itself out.

Unfortunately, TF is subject to the whims and flaws of the vendor API on the device.  TBD if setting some kind of delay/repeat or an explicit `depends-on` relationship will improve this.

### "node" unexpected argument

The following results when assigning a partition permission to the service account of anything less than "manager" (for example, "application manager").  It's likely that the node can be created but then not subsequently updated (see the "error modifying node" bit) in a followup operation.  With "manager" level permissions, this doesn't happen.

```bash

│ Error: error modifying node /Enterprise/some-hostname.it.tufts.edu: "node" unexpected argument
│ 
│   with bigip_ltm_node.node["02"],
│   on test.tf line 25, in resource "bigip_ltm_node" "node":
│   25: resource "bigip_ltm_node" "node" {
│ 
```
