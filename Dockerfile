FROM php:7.2-cli-alpine

MAINTAINER Mikael Kermorgant <mikael@kgtech.fi>


# Install dependencies
RUN apk --no-cache --update add \
    icu \
    libxml2-dev \
    libsasl \
    db \
    postgresql-dev \
    sqlite-dev \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    && apk add --no-cache --virtual .php-deps \
       make \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        zlib-dev \
        icu-dev \
        g++ \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/* \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
        intl \
        opcache \
        pdo_pgsql \
    && docker-php-ext-enable intl \
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && apk del .build-deps \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/* \
    && mkdir /var/www

WORKDIR /var/www
