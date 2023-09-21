ARG BASE_TAG=8-dev
FROM wodby/drupal-php:${BASE_TAG}

ARG COPY_FROM=.
ARG COPY_TO=.
COPY --chown=1000:1000 ${COPY_FROM} ${COPY_TO}

USER root

# Copy Tailscale binaries from the tailscale image on Docker Hub.
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/local/bin/tailscaled
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /usr/local/bin/tailscale
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/containerboot /usr/local/bin/ts-containerboot

COPY ${COPY_FROM}/infrastructure/docker/drupal-tailscale/init-tailscale.sh /docker-entrypoint-init.d/

# Set default values for Tailscale environment variables.
ENV TS_USERSPACE=true
ENV TS_AUTH_ONCE=true
ENV TS_STATE_DIR=/tmp/tailscale
ENV TS_SOCKET=/var/run/tailscale/tailscaled.sock
ENV TS_EXTRA_ARGS="--ssh"

# Create Tailscale state directory, socket and ensure all files are owned by the default user.
RUN mkdir -p ${TS_STATE_DIR}/ $(dirname ${TS_SOCKET})/ && \
  chown -R wodby:wodby ${TS_STATE_DIR}/ $(dirname ${TS_SOCKET})/ && \
  chmod +x /usr/local/bin/tailscaled /usr/local/bin/tailscale /usr/local/bin/ts-containerboot /docker-entrypoint-init.d/init-tailscale.sh

USER wodby

# Tailscale state directory should be mounted to persist across restarts.
VOLUME "/tmp/tailscale"

# This container is intended to be run as a sidecar to the main Drupal container.
CMD [ "sleep", "infinity" ]

HEALTHCHECK CMD ["tailscale", "status"]
