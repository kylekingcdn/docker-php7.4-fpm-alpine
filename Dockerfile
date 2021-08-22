FROM php:7.4-fpm-alpine

ARG APCU_VERSION=5.1.19

# Install production dependencies
RUN apk add --no-cache --update \
      acl \
      git \
      icu-libs \
      libpng \
      libzip \
      openssh \
      openssl \
      zlib

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
      ${PHPIZE_DEPS} \
      icu-dev \
      libpng-dev  \
      libzip-dev \
      zlib-dev

# Install php extensions
RUN docker-php-ext-configure \
      zip && \
    docker-php-ext-install --jobs "$(nproc)" \
      bcmath \
      exif \
      gd \
      intl \
      pcntl \
      pdo \
      pdo_mysql \
      zip && \
    pecl install \
      amqp \
      apcu-${APCU_VERSION} \
      redis && \
    pecl clear-cache && \
    docker-php-ext-enable \
      amqp \
      apcu \
      opcache \
      redis

# Purge build dependencies and temp files
RUN apk del -f .build-deps && \
    rm -rf /tmp/*
