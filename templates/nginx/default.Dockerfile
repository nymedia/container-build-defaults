ARG BASE_TAG=1
ARG BASE_IMAGE=wodby/nginx
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

# Creates a symlink to the default location where the persistent files are stored.
#
# This is usually done at runtime by calling the makefiles script, but to avoid
# having to run the script every time the container is started, we do it here for
# the default location.
RUN set -e ;\
  rm -rvf "${DRUPAL_FILES_DIR}" ;\
  ln -vs "${FILES_DIR}/public" "${DRUPAL_FILES_DIR}"

# Copy error template
COPY ${COPY_FROM}/infrastructure/docker/nginx/50x.html.tmpl /etc/gotpl/50x.html.tmpl
