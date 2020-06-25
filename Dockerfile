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

RUN docker-php-ext-install mysqli && \
    docker-php-ext-install pdo_mysql
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apk add --update nodejs-current npm

# Add user for laravel application
RUN addgroup -S -g ${PGID} ${GROUP}

RUN adduser -S \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$GROUP" \
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
