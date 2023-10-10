ARG BASE_TAG=8-dev
FROM wodby/drupal-php:${BASE_TAG}

ARG COPY_FROM=.
ARG COPY_TO=.
COPY --chown=1000:1000 ${COPY_FROM} ${COPY_TO}

# Copy the required crontab file
COPY ${COPY_FROM}/infrastructure/docker/drupal-cron/www-data.crontab /etc/crontabs/www-data

USER root

# Ensure the drupal logs directory exists and is owned by the webserver user.
ARG DRUPAL_LOGS_DIR=/var/www/html/logs
RUN set -e ;\
  mkdir -p ${DRUPAL_LOGS_DIR} ;\
  chown www-data:www-data ${DRUPAL_LOGS_DIR} ;\
  chmod 775 ${DRUPAL_LOGS_DIR}

USER wodby
