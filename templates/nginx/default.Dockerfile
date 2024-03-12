ARG BASE_TAG=1
ARG BASE_IMAGE=wodby/nginx
FROM ${BASE_IMAGE}:${BASE_TAG}

ARG COPY_FROM=.
ARG COPY_TO=.
COPY --chown=1000:1000 ${COPY_FROM} ${COPY_TO}

# Copy error template
COPY ${COPY_FROM}/infrastructure/docker/nginx/50x.html.tmpl /etc/gotpl/50x.html.tmpl
