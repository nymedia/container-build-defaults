#!/usr/bin/env bash

# Start and configure tailscale(d) using the same setup as the official tailscale container:
# @see https://hub.docker.com/r/tailscale/tailscale
# @see https://github.com/tailscale/tailscale/blob/main/cmd/containerboot/main.go

# We don't want this action to block the boot process, so we run it in the background.
/usr/local/bin/ts-containerboot &
