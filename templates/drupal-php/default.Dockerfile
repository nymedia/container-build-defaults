ARG BASE_TAG=8-dev
ARG BASE_IMAGE=wodby/drupal-php
FROM ${BASE_IMAGE}:${BASE_TAG}

ARG COPY_FROM=.
ARG COPY_TO=.
COPY --chown=1000:1000 ${COPY_FROM} ${COPY_TO}

# Define our default values for environment variables, those can be overridden at runtime.
ARG FILES_DIR=/mnt/files
ARG APP_ROOT=/var/www/html
ARG DOCROOT_SUBDIR=drupal
ARG DRUPAL_SITE=default

ENV FILES_DIR=${FILES_DIR}
ENV APP_ROOT=${APP_ROOT}
ENV DOCROOT_SUBDIR=${DOCROOT_SUBDIR}

ENV DRUPAL_SITE=${DRUPAL_SITE}
ENV DRUPAL_ROOT=${APP_ROOT}/${DOCROOT_SUBDIR}
ENV DRUPAL_SITE_DIR=${DRUPAL_ROOT}/sites/${DRUPAL_SITE}
ENV DRUPAL_FILES_DIR=${DRUPAL_SITE_DIR}/files
ENV DRUPAL_FILES_SYNC_SALT=not-in-use-but-required
ENV DRUPAL_PHP_STORAGE_DIR=/tmp/php

# Creates a symlink to the default location where the persistent files are stored.
#
# This is usually done at runtime by calling the makefiles script, but to avoid
# having to run the script every time the container is started, we do it here for
# the default location.
RUN set -e ;\
  rm -rvf "${DRUPAL_FILES_DIR}" ;\
  ln -vs "${FILES_DIR}/public" "${DRUPAL_FILES_DIR}"

USER root

# Ensure the drupal logs directory exists and is owned by the webserver user.
ARG DRUPAL_LOGS_DIR=/var/www/html/logs
RUN set -e ;\
  mkdir -p ${DRUPAL_LOGS_DIR} ;\
  chown www-data:www-data ${DRUPAL_LOGS_DIR} ;\
  chmod 775 ${DRUPAL_LOGS_DIR}

# Ensure the PHP storage directory exists and it is owned by the webserver user
RUN  mkdir ${DRUPAL_PHP_STORAGE_DIR} ;\
  chown -R www-data:www-data ${DRUPAL_PHP_STORAGE_DIR}

USER wodby
