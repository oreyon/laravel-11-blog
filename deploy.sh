#!/bin/bash

# Continuous Integration
echo "Build..."
cd src || exit
rm -rf vendor
composer install --no-dev --optimize-autoloader

# Continuous Deployment
echo "Deploy..."
rsync --exclude ".git" --exclude "storage" -av --delete . $APP_PATH/.

cd $APP_PATH/ || exit

echo "Clear cache..."
php artisan cache:clear

echo "Database Migration..."
php artisan migrate:fresh --seed

echo "Reload PHP & Nginx"
sudo systemctl reload php8.3-fpm
sudo systemctl reload nginx
