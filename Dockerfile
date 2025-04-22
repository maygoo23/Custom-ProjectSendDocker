# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheSpad"

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
    git && \
  echo "**** fetch custom ProjectSend source ****" && \
  git clone --depth=1 https://github.com/maygoo23/Custom-ProjectSend.git /app/www/public && \
  mv /app/www/public/upload /defaults/ && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*

# copy any local override files
COPY root/ /

# expose ports and volumes
EXPOSE 80 443
VOLUME /config
