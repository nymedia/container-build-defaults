#!/usr/bin/env bash

mkdir -p /tmp/tailscale
/var/runtime/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
/var/runtime/tailscale up --ssh --authkey=${TAILSCALE_AUTHKEY} --hostname=${TAILSCALE_NAME}
echo "Tailscale started!"
