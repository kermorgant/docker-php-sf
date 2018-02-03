FROM php:7.2-cli-alpine

MAINTAINER Mikael Kermorgant <mikael@kgtech.fi>

# Install dependencies
RUN apk --no-cache --update add \
libxml2-dev \
libsasl \
db \
postgresql-dev \
sqlite-dev \
curl \
libpng-dev \
libjpeg-turbo-dev \
freetype-dev && \
rm -rf /tmp/* && \
rm -rf /var/cache/apk/* \
mkdir /var/www

# Configure PHP extensions
RUN docker-php-ext-install opcache && \
    docker-php-ext-install pdo_pgsql

WORKDIR /var/www
