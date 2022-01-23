FROM php:7.4-fpm-alpine

ARG APCU_VERSION=5.1.21

# Install production dependencies
RUN apk add --no-cache --update \
      acl \
      git \
      icu-libs \
      imap-dev \
      libpng \
      libzip \
      openssh \
      openssl \
      rabbitmq-c \
      zlib

# Install build dependencies (xdebug is installed but not enabled)
RUN apk add --no-cache --virtual .build-deps \
      ${PHPIZE_DEPS} \
      icu-dev \
      libpng-dev  \
      libzip-dev \
      openssl-dev \
      rabbitmq-c-dev \
      zlib-dev && \
    docker-php-ext-configure \
      zip && \
    docker-php-ext-configure \
      imap --with-imap-ssl && \
    docker-php-ext-install --jobs "$(nproc)" \
      bcmath \
      exif \
      gd \
      imap \
      intl \
      pcntl \
      pdo \
      pdo_mysql \
      zip && \
    pecl install \
      amqp \
      apcu-${APCU_VERSION} \
      redis \
      xdebug && \
    pecl clear-cache && \
    docker-php-ext-enable \
      amqp \
      apcu \
      opcache \
      redis && \
    apk del -f .build-deps && \
    rm -rf /tmp/*
