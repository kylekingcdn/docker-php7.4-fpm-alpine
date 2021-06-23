FROM php:7.4-fpm-alpine

# Install production dependencies
RUN apk add --no-cache --update \
      libpng \
      openssh \
      zlib \
      zip \
      unzip

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
      ${PHPIZE_DEPS} \
      libpng-dev  \
      libzip-dev \
      zlib-dev

# Install php extensions
RUN docker-php-ext-install --jobs "$(nproc)" \
      bcmath \
      exif \
      gd \
      pdo \
      pdo_mysql \
      zip

# Install redis php extension
RUN pecl install redis && \
    docker-php-ext-enable redis

# Purge build dependencies and temp files
RUN apk del -f .build-deps && \
    rm -rf /tmp/*
