# Properties

Not everything is necessarily straightforward between the web UI and the `F5Networks/bigip` provider.  When things get complicated, document it here.

## VIP level

### SMTP profile

While the web UI has a separate setting/box for "SMTP Profile", this actually maps under the hood to just another "service profile."  If you need this, pass something like the following to the module (and yes, you MUST include the tcp one):

`vip_profiles_list = ["/Common/tcp", "/Common/smtp"]`

### irules

If you're applying an irule that uses HTTP_REQUEST, you might see a similar error:

> Error: 01071912:3: HTTP_REQUEST event in rule (/Enterprise/my-irule) requires an associated HTTP or FASTHTTP profile on the virtual-server (/Enterprise/my-vip).  You can resolve this by passing the `http` profile (or a child thereof):

`profiles = ["/Common/http"]`

TBD if:

- this is required to be on `profiles` (both client and server) or just one or the other
- you also still need the `tcp` profile in addition

## Pool level

### SMTP health checks

The F5 docs state:

> Important: The SMTP monitor must be configured to send a Domain name.

except that the `bigip_ltm_monitor` resource doesn't have a property to reflect this.  When a live setup is `terraform import`ed, the provider ignores and removes that property in the resulting state output.

For now, stmp monitors must be created manually in the web UI and and added to the pool via string, such as:

`pool_monitors_list = ["/${local.smtpout_vip_partition}/smtp_25"]`
