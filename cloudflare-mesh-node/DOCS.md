
# Home Assistant Community App: Cloudflare WARP Mesh Node

Cloudflare WARP Mesh Node is a Home Assistant Community App that provides secure, zero-trust mesh networking for your Home Assistant instance and local network using Cloudflare WARP and Zero Trust. It enables:

- Secure mesh networking for Home Assistant and your local devices
- Automatic NAT and subnet routing
- App connector mode for secure application access
- Simple status web UI for monitoring


## Prerequisites

- A Home Assistant instance with Supervisor
- A Cloudflare account with Zero Trust enabled: https://dash.teams.cloudflare.com/
- A Cloudflare WARP connector token (see [Cloudflare docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/))


## Installation

1. Open Home Assistant and go to the App Store.
2. Add this repository if not already present: `https://github.com/jondycz/app-cloudflare-mesh-node`
3. Find and install the "Cloudflare WARP Mesh Node" app.
4. Configure the app via the UI or by editing `cloudflare-mesh-node/config.yaml` with your Cloudflare WARP connector token and desired options.
5. Start the app.
6. Check the app logs to verify successful connection to Cloudflare WARP.
7. Open the Web UI of the app to view status and routing information at `http://<homeassistant-ip>:8099`.



## Configuration

All configuration is handled via the app UI or by editing `cloudflare-mesh-node/config.yaml`. Example:

taildrive:
taildrop: true

```yaml
connector_token: "<your-cloudflare-warp-connector-token>"
accept_routes: true
advertise_routes:
   - local_subnets
   - 192.168.1.0/24
snat_subnet_routes: true
log_level: info
override_virtual_networks: []
```


See the comments in `config.yaml` for all available options and their descriptions. Most users only need to set the `connector_token`.


### Key Options

- `connector_token`: Cloudflare WARP Zero Trust connector token (required)
- `accept_routes`: Accept routes from other mesh nodes (default: true)
- `advertise_routes`: List of subnets or `local_subnets` to advertise
- `snat_subnet_routes`: Enable SNAT for advertised subnets (default: true)
- `log_level`: Logging verbosity (default: info)
- `override_virtual_networks`: List of virtual networks to override (advanced)


See [config.yaml](config.yaml) for full schema and advanced options.



## Features

- **Cloudflare WARP registration and connection** via `warp-svc` and `warp-cli`
- **Accept and advertise subnet routes** for mesh networking
- **SNAT for subnet routes** for seamless routing
- **App connector support** for secure application access
- **Status web UI** on port 8099
- **Home Assistant integration**: exposes your Home Assistant instance and local subnets to your Cloudflare Zero Trust network


## Status Web UI

The app runs a simple status web UI on port 8099. Access it at:

   http://<homeassistant-ip>:8099

This page shows current WARP connection status, routes, and logs.

### Option: `always_use_derp`

When enabled forces all peer communication over DERP by disabling the use of
UDP.

This option is disabled by default.

Basically you will never want to enable this option. Try to enable it only, when
you experience that connections to your Home Assistant device regularly freeze
(even when you can ping the device, the web page or the Home Assistant app is
unresponsive), and you have to reload the web page or force stop the Home
Assistant app to make them work again. The root cause can be that your ISP
erroneously drops UDP packets on certain conditions.

### Option: `exit_node`

This option allows you to specify another Tailscale instance as an exit node for
this device.

By setting a device on your network as an exit node, you can use it to
route all your public internet traffic as needed, like a consumer VPN.

More information: [Exit nodes][tailscale_info_exit_nodes]

This option is unused by default. To make it visible on the configuration
editor, click "Show unused optional configuration options" at the bottom of the
page.

**Note:** You can't advertise this device as an exit node and at the same time
specify an exit node to use. See also the "Option: `advertise_exit_node`"
section of this documentation.

**Note:** The `exit-node-allow-lan-access` option is always enabled when an exit
node is specified. This is required by the Home Assistant environment.

### Option: `log_level`

Optionally enable tailscaled debug messages in the app's log. Turn it on only
in case you are troubleshooting, because Tailscale's daemon is quite chatty. If
`log_level` is set to `info` or less severe level, the app also opts out of
client log upload to log.tailscale.io.

The `log_level` option controls the level of log output by the app and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `notice`: Normal but significant events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. App becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `login_server`

This option lets you to specify a custom control server instead of the default
(`https://controlplane.tailscale.com`). This is useful if you are running your
own Tailscale control server, for example, a self-hosted [Headscale] instance.

### Option: `share_homeassistant`

This option allows you to enable Tailscale Serve or Funnel features to present
your Home Assistant instance with a valid certificate on your tailnet or on the
internet.

This option is disabled by default.

Tailscale can provide a TLS certificate for your Home Assistant instance within
your tailnet domain.

This can prevent browsers from warning that HTTP URLs to your Home Assistant
instance look unencrypted (browsers are not aware that the connections between
Tailscale nodes are secured with end-to-end encryption).

With the Tailscale Serve feature, you can access your Home Assistant instance
with the provided certificate within your tailnet from devices already connected
to your tailnet.

With the Tailscale Funnel feature, you can access your Home Assistant instance
with the provided certificate not only within your tailnet but even from the
wider internet using your Tailscale domain (like
`https://homeassistant.tail1234.ts.net`) from devices **without installed
Tailscale VPN client** (for example, on general phones, tablets, and laptops).

**Client** &#8658; _Internet_ &#8658; **Tailscale Funnel** (TCP proxy) &#8658;
_VPN_ &#8658; **Tailscale Serve** (HTTPS proxy) &#8594; **HA** (HTTP web-server)

More information: [Enabling HTTPS][tailscale_info_https],
[Tailscale Serve][tailscale_info_serve], [Tailscale Funnel][tailscale_info_funnel].

1. Configure Home Assistant to be accessible through an HTTP connection (this is
   the default). See [HTTP integration documentation][http_integration] for more
   information. If you still want to use another HTTPS connection to access Home
   Assistant, please use a reverse proxy app.

1. Home Assistant, by default, blocks requests from reverse proxies, like the
   Tailscale Serve. To enable it, add the following lines to your
   `configuration.yaml`, without changing anything (don't forget to restart Home
   Assistant after the changes are saved):

   ```yaml
   http:
     use_x_forwarded_for: true
     trusted_proxies:
       - 127.0.0.1
   ```

1. Navigate to the [DNS page][tailscale_dns] of the admin console:
   - Choose a tailnet name.

   - Enable MagicDNS if not already enabled.

   - Under HTTPS Certificates section, click Enable HTTPS.

1. Optionally, if you want to use Tailscale Funnel, navigate to the [Access
   controls page][tailscale_acls] of the admin console:
   - Add the required `funnel` node attribute to the tailnet policy file. See
     [Tailnet policy file requirement][tailscale_info_funnel_policy_requirement]
     for more information.

1. Restart the app.

**Note**: After initial setup, it can take up to 10 minutes for the domain to
be publicly available.

**Note:** You should not use the port number in the URL that you used
previously to access Home Assistant. Tailscale Serve and Funnel works on the
default HTTPS port 443 (or the port configured in option `share_on_port`).

**Note:** If you encounter strange browser behaviour or strange error messages,
try to clear all site-related cookies, clear all browser cache, and restart the
browser.

### Option: `share_on_port`

This option lets you specify which port the Tailscale Serve and Funnel features
will use to present your Home Assistant instance on the tailnet and on the
internet.

Only ports 443, 8443, and 10000 are allowed by Tailscale.

Port 443 is used by default.

### Option: `snat_subnet_routes`

This option allows subnet devices to see the traffic originating from the subnet
router, and this simplifies routing configuration.

This option is enabled by default.

To support advanced [Site-to-site networking][tailscale_info_site_to_site] (e.g.
to traverse multiple networks), you can disable this functionality, and follow
steps in the [Site-to-site networking][tailscale_info_site_to_site] guide (Note:
The app already handles "IP address forwarding" and "Clamp the MSS to the
MTU" for you).

**Note:** Only disable this option if you fully understand the implications.
Keep it enabled if preserving the real source IP address is not critical for
your use case.

### Option: `stateful_filtering`

This option enables stateful packet filtering on packet-forwarding nodes (exit
nodes, subnet routers, and app connectors), to only allow return packets for
existing outbound connections. Inbound packets that don't belong to an existing
connection are dropped.

This option is disabled by default.

### Option: `tags`

This option allows you to specify specific tags for this Tailscale instance.
They need to start with `tag:`.

More information: [Tags][tailscale_info_tags]

### Option: `taildrive`

This option allows you to specify which Home Assistant directories you want to
share with other Tailscale nodes using Taildrive.

Only the listed directories are available.

These options are disabled by default.

More information: [Taildrive][tailscale_info_taildrive]

### Option: `taildrop`

This app supports [Tailscale's Taildrop][tailscale_info_taildrop] feature,
which allows you to send files to your Home Assistant instance from other
Tailscale devices.

This option is enabled by default.

Received files are stored in the `/share/taildrop` directory.

### Option: `userspace_networking`

The app uses [userspace networking mode][tailscale_info_userspace_networking]
to make your Home Assistant instance (and optionally the local subnets)
accessible within your tailnet.

This option is enabled by default.

If you need to access other clients on your tailnet from your Home Assistant
instance, disable userspace networking mode, which will create a `tailscale0`
network interface on your host.

To be able to address other clients on your tailnet not only by their tailnet IP
but also by their tailnet name, see the "DNS" section of this documentation.

If you want to access other clients on your tailnet even from your local subnet,
follow steps in the [Site-to-site networking][tailscale_info_site_to_site] guide
(Note: The app already handles "IP address forwarding" and "Clamp the MSS to
the MTU" for you).

**Note:** In case your local subnets collide with subnet routes within your
tailnet, your local network access has priority, and these addresses won't be
routed toward your tailnet. This will prevent your Home Assistant instance from
losing network connection. This also means that using the same subnet on
multiple nodes for load balancing and failover is impossible with the current
app behavior.

**Note:** The `userspace_networking` option can remain enabled if you only need
one-way access from tailnet clients to your local subnet, without requiring
access from your local subnet to other tailnet clients.

**Note:** If you implement Site-to-site networking, but you are not interested
in the real source IP address, i.e. subnet devices can see the traffic
originating from the subnet router, you don't need to disable the
`snat_subnet_routes` option, this can simplify routing configuration.


## Networking

The app manages all NAT, routing, and subnet advertisement automatically. No manual port forwarding is required for Cloudflare WARP. Your Home Assistant instance and configured subnets will be accessible from your Cloudflare Zero Trust network.


## Cloudflare Zero Trust Resources

- [Cloudflare Zero Trust Docs](https://developers.cloudflare.com/cloudflare-one/)
- [WARP Connector Setup](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/)


## Changelog & Releases

See [GitHub Releases](https://github.com/jondycz/app-cloudflare-mesh-node/releases) for changelog and version history.


## Support

For issues, feature requests, or questions, please open an issue on [GitHub](https://github.com/jondycz/app-cloudflare-mesh-node/issues).

For Home Assistant-specific questions, visit the [Home Assistant Community Forum](https://community.home-assistant.io/) or the [Discord chat](https://www.home-assistant.io/join-chat).


## Authors & Contributors

Original Tailscale-based version by Franck Nijhof. Cloudflare WARP mesh node adaptation for Home Assistant by jondycz and contributors.

## License

MIT License

Copyright (c) 2021-2026 Franck Nijhof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


