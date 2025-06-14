# syntax=docker.io/docker/dockerfile:1.7-labs
# @see https://stackoverflow.com/a/78110854/558561
ARG PHP_VERSION=8.3
ARG WITH_XDEBUG=true
FROM serversideup/php:${PHP_VERSION}-fpm AS base

USER root

#################################################################################
# DEV: for development — local
#################################################################################
FROM base AS dev

# mysqli needed for WP-CLI
RUN install-php-extensions mysqli

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN if [ $WITH_XDEBUG = "true" ] ; then \
    install-php-extensions xdebug; \
    COPY /config/php-fpm/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/; \
fi ;

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp;

ENV PHP_OPCACHE_ENABLE="0"
USER www-data

COPY /config/environments/ /var/www/html/config/environments/
COPY /config/php-fpm/php.ini /usr/local/etc/php/php.ini
COPY --exclude=*.md /config/ssl/ /etc/ssl/
COPY /config/application.php /var/www/html/config/application.php
COPY /vendor /var/www/html/vendor
COPY /web /var/www/html/web
COPY /.env /var/www/html/.env
COPY /wp-cli.yml /var/www/html/wp-cli.yml

#################################################################################
# DEPLOY: for actual deployment — any environment
#################################################################################
FROM base AS deploy

ENV PHP_OPCACHE_ENABLE="1"
COPY --chown=www-data:www-data . /var/www/html
STOPSIGNAL SIGTERM
USER www-data

COPY /config/environments/ /var/www/html/config/environments/
COPY /config/php-fpm/php.ini /usr/local/etc/php/php.ini
COPY --exclude=*.md /config/ssl/ /etc/ssl/
COPY /config/application.php /var/www/html/config/application.php
COPY /vendor /var/www/html/vendor
COPY /web /var/www/html/web
COPY /.env /var/www/html/.env
COPY /wp-cli.yml /var/www/html/wp-cli.yml
