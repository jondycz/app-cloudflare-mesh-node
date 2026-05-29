ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:7.8.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=amd64
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates=20240203 \
        curl=7.88.1-10+deb12u8 \
        dnsutils=1:9.18.33-1~deb12u2 \
        ethtool=1:6.1-1 \
        gnupg=2.2.40-1.1 \
        ipcalc=0.51-1 \
        iproute2=6.1.0-3 \
        iptables=1.8.9-2 \
        net-tools=2.10-0.1 \
        nginx=1.22.1-9 \
        procps=2:4.0.2-3 \
        network-manager=1.42.4-1 \
    \
    && curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg \
        | gpg --dearmor -o /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bookworm main" \
        > /etc/apt/sources.list.d/cloudflare-client.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        cloudflare-warp=2024.6.497-1 \
    \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    \
    && rm -f -r /usr/lib/NetworkManager/dispatcher.d \
    && mkdir -p /var/lib/cloudflare-warp

# Copy root filesystem
COPY rootfs /

HEALTHCHECK \
    CMD healthcheck

# S6 Overlay stage 2 hook
ENV S6_STAGE2_HOOK=/etc/s6-overlay/scripts/stage2_hook.sh

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Home Assistant Community" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Apps" \
    org.opencontainers.image.authors="Home Assistant Community" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
