#!/command/with-contenv bashio
# shellcheck shell=bash
export LOG_FD
# ==============================================================================
# Home Assistant Community App: Cloudflare WARP Mesh Node
# S6 Overlay stage2 hook to customize services
# ==============================================================================

# This is to execute potentially failing supervisor api functions within conditions,
# where set -e is not propagated inside the function and bashio relies on set -e for api error handling
function try {
    set +e
    (set -e; "$@")
    declare -gx TRY_ERROR=$?
    set -e
}

# Disable protect-subnets service when accepting routes is disabled
if bashio::config.false "accept_routes"; then
    rm -f /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/protect-subnets
fi

# If local subnets are not configured in advertise_routes, do not wait for the local network
if ! bashio::config "advertise_routes" | grep -Fxq "local_subnets"; then
    rm -f /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/local-network
fi

# Remove MagicDNS-related services (not used in WARP)
rm -f /etc/s6-overlay/s6-rc.d/tailscaled/dependencies.d/magicdns-egress-proxy
rm -f /etc/s6-overlay/s6-rc.d/tailscaled/dependencies.d/init-magicdns-ingress-proxy
rm -f /etc/s6-overlay/s6-rc.d/user/contents.d/magicdns-ingress-proxy
rm -f /etc/s6-overlay/s6-rc.d/forwarding/dependencies.d/magicdns-ingress-proxy

# Remove Tailscale-specific services (not used in WARP)
rm -f /etc/s6-overlay/s6-rc.d/user/contents.d/taildrop
rm -f /etc/s6-overlay/s6-rc.d/user/contents.d/taildrive
rm -f /etc/s6-overlay/s6-rc.d/user/contents.d/share-homeassistant
