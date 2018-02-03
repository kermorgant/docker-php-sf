FROM php:7.2-cli-alpine

MAINTAINER Mikael Kermorgant <mikael@kgtech.fi>

# Install dependencies
RUN apk --no-cache --update add \
libxml2-dev \
libsasl \
db \
postgresql-libs \
postgresql-dev \
sqlite-dev \
curl \
curl-dev \
icu-dev \
libpng-dev \
libjpeg-turbo-dev \
freetype-dev && \
rm -rf /tmp/* && \
rm -rf /var/cache/apk/*

# Configure PHP extensions
RUN docker-php-ext-configure json && \
docker-php-ext-install opcache \
docker-php-ext-configure session && \
docker-php-ext-configure ctype && \
docker-php-ext-install intl \
docker-php-ext-configure tokenizer && \
docker-php-ext-configure simplexml && \
docker-php-ext-configure dom && \
docker-php-ext-configure mbstring && \
docker-php-ext-configure zip && \
docker-php-ext-configure pdo && \
docker-php-ext-configure pdo_sqlite && \
docker-php-ext-configure pdo_mysql && \
docker-php-ext-configure pdo_pgsql && \
docker-php-ext-configure curl && \
docker-php-ext-configure iconv && \
docker-php-ext-configure xml && \
docker-php-ext-configure phar && \
docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

WORKDIR /srv
