FROM johnpbloch/phpfpm:7.1

RUN curl -L https://phar.phpunit.de/phpunit.phar > /tmp/phpunit.phar \
    && chmod +x /tmp/phpunit.phar \
    && mv /tmp/phpunit.phar /usr/local/bin/phpunit

# Install OS utilities
RUN apt-get update
RUN apt-get -y install \
    curl \
    iputils-ping \
    net-tools \
    git \
    zip \
    unzip \
    wget \
    vim

CMD ["php-fpm"]

EXPOSE 9000