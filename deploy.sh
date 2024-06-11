#!/bin/bash

# To run this deploy.sh file, you need to give it execute permission
# To give execute permission, run the following command
# go to the directory where the deploy.sh file is located and run the following command
# chmod +x deploy.sh
# chmod +x /var/www/laravel/deploy.sh


# Set up environment variables
APP_PATH=${APP_PATH:-'/var/www/laravel'}
chmod +x deploy.sh

# Continuous Integration
echo "Build..."
cd $APP_PATH || exit
git pull # Pull the latest changes from the repository
rm -rf vendor
composer install --no-dev --optimize-autoloader
npm install
npm build

echo "Test..."
/vendor/bin/phpunit

# Continuous Deployment
echo "Deploy..."
rsync --exclude ".git" --exclude "storage" -av --delete . $APP_PATH/.

cd $APP_PATH || exit

echo "Clear cache..."
php artisan cache:clear

echo "Database Migration..."
php artisan migrate --force

echo "Reload PHP & Nginx"
sudo systemctl reload php8.3-fpm
sudo systemctl reload nginx