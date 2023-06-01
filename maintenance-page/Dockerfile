ARG BASE_TAG=latest
FROM wodby/nginx:${BASE_TAG}

ENV NGINX_VHOST_PRESET="maintenance-page" \
  NGINX_DISABLE_CACHING="true"

COPY ./nginx-preset.conf.tmpl /etc/gotpl/presets/maintenance-page.conf.tmpl

COPY ./maintenance-page.html /var/www/html/
