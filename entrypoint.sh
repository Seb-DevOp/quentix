#!/bin/sh

npm install tailwindcss postcss autoprefixer --save-dev

# Copier .env.example si .env n'existe pas
if [ ! -f /var/www/html/.env ]; then
    cp /var/www/html/.env.example /var/www/html/.env
fi

# Vérifier si les variables existent dans le fichier .env, sinon les ajouter
grep -q "^APP_URL=" /var/www/html/.env || echo "APP_URL=http://localhost" >> /var/www/html/.env
grep -q "^VITE_PORT=" /var/www/html/.env || echo "VITE_PORT=5173" >> /var/www/html/.env
grep -q "^VITE_HOST=" /var/www/html/.env || echo "VITE_HOST=localhost" >> /var/www/html/.env

# Forcer les variables MySQL
sed -i 's|DB_CONNECTION=.*|DB_CONNECTION=mysql|' /var/www/html/.env
sed -i 's|# DB_HOST=.*|DB_HOST=192.168.10.100|' /var/www/html/.env
sed -i 's|# DB_PORT=.*|DB_PORT=3306|' /var/www/html/.env
sed -i 's|# DB_DATABASE=.*|DB_DATABASE=Quentix_DB|' /var/www/html/.env
sed -i 's|# DB_USERNAME=.*|DB_USERNAME=laravel_user|' /var/www/html/.env
sed -i 's|# DB_PASSWORD=.*|DB_PASSWORD=L@r@velPass123|' /var/www/html/.env

php artisan key:generate

php artisan migrate --force

# Démarrer Laravel et Vite en arrière-plan
php artisan serve --host=0.0.0.0 --port=8000 &
npm run dev &

# Lancer php-fpm en avant-plan pour maintenir le conteneur actif
exec php-fpm
