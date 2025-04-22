# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Custom ProjectSend version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="maygoo23"

# install required packages: php extensions + git + composer + node/npm
RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    php83-bcmath \
    php83-bz2 \
    php83-cli \
    php83-dom \
    php83-gd \
    php83-gettext \
    php83-gmp \
    php83-mysqli \
    php83-pdo \
    php83-pdo_dblib \
    php83-pdo_mysql \
    php83-pecl-apcu \
    php83-pecl-mcrypt \
    php83-pecl-memcached \
    php83-soap \
    php83-xmlreader \
    php83-exif \
    git \
    composer \
    npm \
    nodejs && \
  echo "**** fetch custom ProjectSend source ****" && \
  git clone --depth=1 https://github.com/maygoo23/Custom-ProjectSend.git /app/www/public

# build backend dependencies (PHP)
RUN cd /app/www/public && \
    composer install --no-dev --optimize-autoloader || true

# build frontend assets (optional, only if applicable)
RUN cd /app/www/public && \
    [ -f gulpfile.js ] && npm install && npx gulp build || echo "No frontend build needed"

# move default upload folder into persistent config area
RUN mv /app/www/public/upload /defaults/ || true

# copy nginx + php-fpm config
COPY root/ /

# expose standard web ports and mount volumes
EXPOSE 80 443
VOLUME /config /data
