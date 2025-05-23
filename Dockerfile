# Use official PHP image with Apache
FROM php:8.1-apache

# Enable apache mod_rewrite if needed
RUN a2enmod rewrite

# Install system dependencies and PHP extensions for composer
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
  && docker-php-ext-install zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy current directory content to working directory
COPY . /var/www/html

# Run composer install if composer.json is present
RUN if [ -f composer.json ]; then composer install; fi

# Expose port 80
EXPOSE 80

# Start apache in the foreground
CMD ["apache2-foreground"]
