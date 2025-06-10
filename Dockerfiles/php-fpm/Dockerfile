ARG PHP_VERSION=8.3
ARG WITH_XDEBUG=true
FROM serversideup/php:${PHP_VERSION}-fpm-alpine AS base

USER root

#################################################################################
# DEV: for development — local
#################################################################################
FROM base AS dev

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN if [ $WITH_XDEBUG = "true" ] ; then \
    install-php-extensions xdebug; \
    COPY /config/php-fpm/docker-php-ext-xdebug.ini:/usr/local/etc/php/conf.d/; \
fi ;

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp;

ENV PHP_OPCACHE_ENABLE="0"
USER www-data

#################################################################################
# DEPLOY: for actual deployment — any environment
#################################################################################
FROM base AS deploy

ENV PHP_OPCACHE_ENABLE="1"
COPY --chown=www-data:www-data . /var/www/html
STOPSIGNAL SIGTERM
USER www-data
