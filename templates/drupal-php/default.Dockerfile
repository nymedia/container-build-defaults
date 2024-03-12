ARG BASE_TAG=8-dev
ARG BASE_IMAGE=wodby/drupal-php
FROM ${BASE_IMAGE}:${BASE_TAG}

ARG COPY_FROM=.
ARG COPY_TO=.
COPY --chown=1000:1000 ${COPY_FROM} ${COPY_TO}

USER root

# Ensure the drupal logs directory exists and is owned by the webserver user.
ARG DRUPAL_LOGS_DIR=/var/www/html/logs
RUN set -e ;\
  mkdir -p ${DRUPAL_LOGS_DIR} ;\
  chown www-data:www-data ${DRUPAL_LOGS_DIR} ;\
  chmod 775 ${DRUPAL_LOGS_DIR}

USER wodby
