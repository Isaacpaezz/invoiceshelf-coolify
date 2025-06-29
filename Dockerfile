# 1) Base PHP + SQLite
FROM php:8.2-cli-alpine

RUN apk add --no-cache oniguruma-dev sqlite-dev libzip-dev \
 && docker-php-ext-install pdo pdo_sqlite mbstring zip exif

# 2) Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# 3) Instala dependencias
COPY composer.json composer.lock ./

# Debug: lista archivos antes de instalar dependencias
RUN ls -lR /app/app/Space

RUN composer install --no-dev --optimize-autoloader

# 4) Código de la app
COPY . .

# 5) Genera APP_KEY y prepara DB
RUN php artisan key:generate \
 && touch database/database.sqlite

# 6) Expone y arranca el servidor de desarrollo
EXPOSE 3000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
