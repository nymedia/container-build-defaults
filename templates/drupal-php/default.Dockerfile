ARG BASE_TAG=8-dev
ARG BASE_IMAGE=wodby/drupal-php
FROM ${BASE_IMAGE}:${BASE_TAG}

ARG COPY_FROM=.
ARG COPY_TO=.
COPY --chown=1000:1000 ${COPY_FROM} ${COPY_TO}

# Define our default values for environment variables, those can be overridden at runtime.
ENV FILES_DIR=/mnt/files
ENV APP_ROOT=/var/www/html
ENV DOCROOT_SUBDIR=drupal

ENV DRUPAL_SITE=default
ENV DRUPAL_ROOT=${APP_ROOT}/${DRUPAL_ROOT}
ENV DRUPAL_SITE_DIR=$(DRUPAL_ROOT)/sites/$(DRUPAL_SITE)
ENV DRUPAL_FILES_DIR=${DRUPAL_SITE_DIR}/files
ENV DRUPAL_FILES_SYNC_SALT=not-in-use-but-required

USER root

# Ensure the drupal logs directory exists and is owned by the webserver user.
ARG DRUPAL_LOGS_DIR=/var/www/html/logs
RUN set -e ;\
  mkdir -p ${DRUPAL_LOGS_DIR} ;\
  chown www-data:www-data ${DRUPAL_LOGS_DIR} ;\
  chmod 775 ${DRUPAL_LOGS_DIR}

USER wodby
