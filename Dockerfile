FROM php:7.2-cli-alpine

MAINTAINER Mikael Kermorgant <mikael@kgtech.fi>


# Install dependencies
RUN apk --no-cache --update add \
    libsasl \
    db \
    curl \
    && apk add --no-cache --virtual .php-deps \
       make \
       freetype \
       icu \
       libpng \
       libjpeg-turbo \
       libxml2 \
       postgresql-libs \
       sqlite-libs \
       zlib \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        freetype-dev \
        g++ \
        icu-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libxml2-dev \
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
        pdo \
        pdo_mysql \
        pdo_pgsql \
        zip \
    && docker-php-ext-enable \
       pdo \
       pdo_mysql \
       pdo_pgsql \
       intl \
       xdebug \
    && apk del .build-deps \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/* \
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && mkdir /var/www


ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 1.6.3

RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer \
 && php -r " \
    \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
    \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
    if (!hash_equals(\$signature, \$hash)) { \
        unlink('/tmp/installer.php'); \
        echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
        exit(1); \
    }" \
 && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
 && composer --ansi --version --no-interaction \
 && rm -rf /tmp/*

WORKDIR /var/www
COPY ["entrypoint.sh", "/"]
ENTRYPOINT ["/entrypoint.sh"]
