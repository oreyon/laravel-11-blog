#!/bin/bash

# To run this deploy.sh file, you need to give it execute permission
# To give execute permission, run the following command
# go to the directory where the deploy.sh file is located and run the following command
# chmod +x deploy.sh
# chmod +x /var/www/laravel/deploy.sh


echo "SETTING ENVIRONMENT VARIABLES"
APP_PATH=${_ENV_APP_PATH:-''}
ENV_ZONE=${_ENV_ZONE:-''}
ENV_INST_USER=${_ENV_INST_USER:-''}
ENV_INST_NAME=${_ENV_INST_NAME:-''}
ENV_APP_PATH=${_ENV_APP_PATH:-''}
ENV_PULL_PATH=${_ENV_PULL_PATH:-''}
ENV_BRANCH=${_ENV_BRANCH:-''}
echo "APP_PATH: $APP_PATH"
echo "ENV_ZONE: $ENV_ZONE"
echo "ENV_INST_USER: $ENV_INST_USER"
echo "ENV_INST_NAME: $ENV_INST_NAME"
echo "ENV_APP_PATH: $ENV_APP_PATH"
echo "ENV_PULL_PATH: $ENV_PULL_PATH"
echo "ENV_BRANCH: $ENV_BRANCH"

# Ensure NVM script is executable
chmod +x /home/$ENV_INST_USER/.nvm/nvm.sh

# source /home/c663bsy4320/.nvm/nvm.sh
NVM=/home/$_ENV_INST_USER/.nvm/nvm.sh
source $NVM
echo "NVM Location: $NVM"


# Continuous Integration
echo "Build..."
cd $APP_PATH || exit
sudo rm -rf vendor

echo "Change ownership root"
sudo chown root:root $APP_PATH

echo "Composer Install"
composer install --no-dev --optimize-autoloader
composer update

echo "NPM INSTALL"
npm install
echo "NPM BUILD"
npm run build

echo "Test..."
cd $APP_PATH || exit
php artisan test

# Continuous Deployment
echo "Deploy..."
rsync --exclude ".git" --exclude "storage" -av --delete . $APP_PATH/.

cd $APP_PATH || exit

echo "Clear cache..."
php artisan cache:clear

echo "Database Migration..."
php artisan migrate --force


echo "Ensure the web server can write to the storage and cache directories"
sudo chown -R www-data:www-data $APP_PATH/storage
sudo chmod -R 775 $APP_PATH/storage

echo "Reload PHP & Nginx"
sudo systemctl reload php8.3-fpm
sudo systemctl reload nginx

# If there were stashed changes, apply them back
git stash pop || true