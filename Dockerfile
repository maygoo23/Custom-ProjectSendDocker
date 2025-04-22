# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.21

# Set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Custom ProjectSend version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="maygoo23"

# Install dependencies
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
    nodejs

# Clone your custom ProjectSend fork
RUN git clone --depth=1 https://github.com/maygoo23/Custom-ProjectSend.git /app/www/public

# Install PHP dependencies (vendor/)
RUN cd /app/www/public && \
    if [ -f composer.json ]; then \
      composer install --no-dev --optimize-autoloader || (echo "❌ Composer install failed" && exit 1); \
    else \
      echo "⚠️ No composer.json found, skipping composer install"; \
    fi

# Optional frontend build (only if gulpfile.js exists)
RUN cd /app/www/public && \
    if [ -f gulpfile.js ]; then \
      npm install && npx gulp build; \
    else \
      echo "No frontend build needed"; \
    fi

# Move default upload folder into config volume (for persistence)
RUN mv /app/www/public/upload /defaults/ || true

# Ensure /app/www/public/emails exists with correct permissions
RUN mkdir -p /app/www/public/emails && \
    chmod 755 /app/www/public/emails && \
    chown -R abc:abc /app/www/public/emails

# Copy LSIO overlay configs (s6, nginx, php)
COPY root/ /

# Expose web ports and declare volumes
EXPOSE 80 443
VOLUME /config /data
