# Properties

Not everything is necessarily straightforward between the web UI and the `F5Networks/bigip` provider.  When things get complicated, document it here.

## VIP level

### SMTP profile

While the web UI has a separate setting/box for "SMTP Profile", this actually maps under the hood to just another "service profile."  If you need this, pass something like the following to the module (and yes, you MUST include the tcp one):

`vip_profiles_list = ["/Common/tcp", "/Common/smtp"]`
