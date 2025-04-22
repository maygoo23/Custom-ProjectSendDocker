# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PROJECTSEND_VERSION=main
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="maygoo23"

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
  echo "**** install projectsend ****" && \
  mkdir -p /app/www/public && \
  git clone --branch ${PROJECTSEND_VERSION} https://github.com/maygoo23/Custom-ProjectSend.git /app/www/public && \
  rm -rf /app/www/public/.git && \
  mv /app/www/public/upload /defaults/ && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
