FROM php:7.4-fpm-alpine

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
      pcov \
      redis \
      xdebug && \
    pecl clear-cache && \
    docker-php-ext-enable \
      amqp \
      opcache \
      redis && \
    apk del -f .build-deps && \
    rm -rf /tmp/*
