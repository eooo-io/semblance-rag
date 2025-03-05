FROM alpine:3.18

RUN apk add --no-cache \
    php84 \
    php84-fpm \
    php84-pdo \
    php84-pdo_pgsql \
    php84-json \
    php84-openssl \
    php84-curl \
    php84-zlib \
    php84-xml \
    php84-phar \
    php84-intl \
    php84-dom \
    php84-mbstring \
    php84-gd \
    php84-session

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy Laravel application files
COPY ./webapp /var/www/html

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm84", "-F"]
