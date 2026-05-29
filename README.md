
# Cloudflare WARP Mesh Node

[![GitHub Release](https://img.shields.io/github/release/jondycz/app-cloudflare-mesh-node.svg)](https://github.com/jondycz/app-cloudflare-mesh-node/releases)
![Project Stage](https://img.shields.io/badge/project%20stage-experimental-yellow.svg)
[![License](https://img.shields.io/github/license/jondycz/app-cloudflare-mesh-node.svg)](LICENSE.md)

![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)

[![GitHub Actions](https://github.com/jondycz/app-cloudflare-mesh-node/workflows/CI/badge.svg)](https://github.com/jondycz/app-cloudflare-mesh-node/actions)
![Project Maintenance](https://img.shields.io/maintenance/yes/2026.svg)
[![GitHub Activity](https://img.shields.io/github/commit-activity/y/jondycz/app-cloudflare-mesh-node.svg)](https://github.com/jondycz/app-cloudflare-mesh-node/commits/main)

Cloudflare WARP mesh connector for secure, zero-trust networking between containers, VMs, and physical hosts. Provides automatic NAT, subnet routing, and app connector functionality using Cloudflare Zero Trust.

## About

This project provides a containerized Cloudflare WARP mesh node, designed to function as a drop-in replacement for Tailscale-based mesh VPNs. It enables:

- Secure, zero-config mesh networking using Cloudflare WARP and Zero Trust
- Automatic NAT and subnet routing for local networks
- App connector mode for secure application access
- Simple status web UI for monitoring

**Features:**
- Cloudflare WARP registration and connection via `warp-svc` and `warp-cli`
- Accept and advertise subnet routes
- SNAT for subnet routes
- App connector support
- Status web UI on port 8099

See [:books: Full documentation](cloudflare-mesh-node/DOCS.md) for details.


## Usage

1. **Configure**: Edit `cloudflare-mesh-node/config.yaml` with your Cloudflare WARP connector token and desired options (see below).
2. **Build & Run**: Use the provided Dockerfile to build and run the container, or deploy via your preferred orchestrator.
3. **Register**: The container will register with Cloudflare WARP using your token and connect automatically.
4. **Monitor**: Access the status web UI at `http://<container-ip>:8099` for connection and routing status.

## Configuration

All configuration is handled via `cloudflare-mesh-node/config.yaml`. Key options:

- `connector_token`: Cloudflare WARP Zero Trust connector token (required)
- `accept_routes`: Accept routes from other mesh nodes (default: true)
- `advertise_routes`: List of subnets or `local_subnets` to advertise
- `snat_subnet_routes`: Enable SNAT for advertised subnets (default: true)
- `log_level`: Logging verbosity (default: info)

See [cloudflare-mesh-node/config.yaml](cloudflare-mesh-node/config.yaml) and [cloudflare-mesh-node/DOCS.md](cloudflare-mesh-node/DOCS.md) for full details.


## Contributing

Contributions, bug reports, and feature requests are welcome! Please open issues or pull requests on [GitHub](https://github.com/jondycz/app-cloudflare-mesh-node).

## License

## License


MIT License

Copyright (c) 2024-present jondycz

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


[releases]: https://github.com/hassio-addons/app-tailscale/releases
[repository]: https://github.com/hassio-addons/repository
