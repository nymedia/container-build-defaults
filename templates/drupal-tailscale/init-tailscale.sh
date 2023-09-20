#!/usr/bin/env bash

# Start and configure tailscale(d) using the same setup as the official tailscale container:
# @see https://hub.docker.com/r/tailscale/tailscale
# @see https://github.com/tailscale/tailscale/blob/main/cmd/containerboot/main.go

/usr/local/bin/ts-containerboot &

# Leave some time for tailscaled to start and connect to the Tailscale network.
sleep 5

# Start the tailscale-powered sshd server.
tailscale set --ssh
echo "Tailscale SSH server enabled."
