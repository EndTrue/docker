FROM php:7.4-fpm-alpine

LABEL DarkSide="blacklife1992@gmail.com"

ARG PUID=1000
ARG PGID=1000
ARG USER=docker
ARG GROUP=docker

# COPY composer.lock composer.json /var/www/

WORKDIR /var/www
USER root
# Install dependencies
#RUN apk --update add \
#        php7-bcmath \
#        php7-dom \
#        php7-ctype \
#        php7-curl \
#        php7-fpm \
#        php7-gd \
#        php7-iconv \
#        php7-intl \
#        php7-json \
#        php7-mbstring \
#        php7-mcrypt \
#        php7-mysqlnd \
#        php7-opcache \
#        php7-openssl \
#        php7-pdo \
#        php7-pdo_mysql \
#        php7-pdo_pgsql \
#        php7-pdo_sqlite \
#        php7-phar \
#        php7-posix \
#        php7-session \
#        php7-soap \
#        php7-xml \
#        php7-zip \
#    && rm -rf /var/cache/apk/*

RUN docker-php-ext-install mysqli && \
    docker-php-ext-install pdo_mysql
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apk add --update nodejs-current npm

# Add user for laravel application
RUN addgroup -g ${PGID} ${GROUP}

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$PUID" \
    "$USER"

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=$USER:$GROUP . /var/www

# Change current user to www
USER $USER

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
