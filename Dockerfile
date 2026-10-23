FROM php:8.5.12-apache

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY config/php.ini /usr/local/etc/php/conf.d/90-defaults.ini

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libxml2-dev \
        libpq-dev \
        libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        pdo_mysql \
        mysqli \
        pdo_pgsql \
        pgsql \
        gd \
        zip \
        soap \
        exif \
        intl \
        bcmath \
        pcntl \
        sockets \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && a2enmod rewrite headers \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
