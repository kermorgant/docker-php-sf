FROM php:7.2-cli-alpine

MAINTAINER Mikael Kermorgant <mikael@kgtech.fi>


# Install dependencies
RUN apk --no-cache --update add \
    icu \
    libxml2-dev \
    libsasl \
    db \
    curl \
    && apk add --no-cache --virtual .php-deps \
       make \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        freetype-dev \
        g++ \
        icu-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        postgresql-dev \
        sqlite-dev \
        zlib-dev \
    && pecl install xdebug-2.6.0 \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd \
       --with-freetype-dir=/usr/include/ \
       --with-png-dir=/usr/include/ \
       --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
        bcmath \
        intl \
        gd \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        zip \
    && docker-php-ext-enable \
       pdo_pgsql \
       intl \
       xdebug \
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && apk del .build-deps \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/* \
    && mkdir /var/www

WORKDIR /var/www
