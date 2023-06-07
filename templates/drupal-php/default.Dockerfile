ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG COPY_FROM
ARG COPY_TO

COPY --chown=1000:1000 ${COPY_FROM} ${COPY_TO}

# Copy the required crontab file
COPY ${COPY_FROM}/infrastructure/docker/cron/www-data.crontab /etc/crontabs/www-data
