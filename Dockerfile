# Gunakan PHP image dengan Apache sebagai web server
FROM php:8.1-apache

# Install ekstensi yang diperlukan untuk Laravel
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql zip && \
    a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Salin proyek Laravel ke dalam container
COPY . /var/www/html
COPY composer.json /var/www/html

# Set folder kerja
WORKDIR /var/www/html

# Install dependensi Laravel
RUN composer install

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port
EXPOSE 80
