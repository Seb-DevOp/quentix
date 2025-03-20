# Utilisation de PHP 8.3 comme base
FROM php:8.3-fpm

# Installer les dépendances système et PHP
RUN apt-get update && apt-get install -y \
    zip \
    git \
    npm \
    zlib1g-dev \
    libpng-dev \
    default-mysql-client \
    && apt-get clean

# Installer les extensions PHP nécessaires
RUN docker-php-ext-install gd pdo pdo_mysql

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier l'entrypoint Laravel + Vite
RUN echo "import { defineConfig } from 'vite';" > vite.config.js && \
    echo "import laravel from 'laravel-vite-plugin';" >> vite.config.js && \
    echo "" >> vite.config.js && \
    echo "export default defineConfig({" >> vite.config.js && \
    echo "    plugins: [" >> vite.config.js && \
    echo "        laravel({" >> vite.config.js && \
    echo "            input: ['resources/css/app.css', 'resources/js/app.js']," >> vite.config.js && \
    echo "            refresh: true," >> vite.config.js && \
    echo "        })," >> vite.config.js && \
    echo "    ]," >> vite.config.js && \
    echo "    server: {" >> vite.config.js && \
    echo "        host: '0.0.0.0'," >> vite.config.js && \
    echo "        port: 5173," >> vite.config.js && \
    echo "        strictPort: true," >> vite.config.js && \
    echo "        hmr: {" >> vite.config.js && \
    echo "            host: '192.168.10.22'," >> vite.config.js && \
    echo "        }" >> vite.config.js && \
    echo "    }" >> vite.config.js && \
    echo "});" >> vite.config.js

# Copier les fichiers du projet (sauf node_modules et vendor si déjà exclus dans .dockerignore)
COPY . /var/www/html
RUN chmod -R 775 /var/www/html && chown -R www-data:www-data /var/www/html

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

RUN npm install

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
