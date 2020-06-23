FROM php:7.4-fpm

LABEL DarkSide="blacklife1992@gmail.com"

# COPY composer.lock composer.json /var/www/

WORKDIR /var/www


# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        libxml2-dev \
        libzip-dev \
        libonig-dev \
        graphviz \
        git \
        nodejs \
        npm \
        nano \
        curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-configure gd 
RUN docker-php-ext-install -j$(nproc) gd 
RUN docker-php-ext-install pdo_mysql 
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install zip 
RUN docker-php-source delete

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]