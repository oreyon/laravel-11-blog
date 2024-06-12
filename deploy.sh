#!/bin/bash

echo "STARTING DEPLOYMENT"
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

echo "SET PERMISSION NVM"
chmod +x /home/$ENV_INST_USER/.nvm/nvm.sh

echo "DETECTING NVM"
NVM=/home/$_ENV_INST_USER/.nvm/nvm.sh
source $NVM
echo "NVM Location: $NVM"


echo "DETECTING PHP"
echo "Build..."
cd $APP_PATH || exit
sudo rm -rf vendor

echo "CHANGE OWNERSHIP"
sudo chown root:root $APP_PATH

# INSTALLING DEPENDENCIES
echo "INSTALLING DEPENDENCIES"
echo "COMPOSER INSTALL"
composer install --no-dev --optimize-autoloader
composer update

echo "INSTALLING NPM"
npm install
echo "NPM BUILD"
npm run build

# TESTING
echo "TESTING CODE"
cd $APP_PATH || exit
php artisan test

# DEPLOYING CODE
echo "DEPLOYING CODE"
rsync --exclude ".git" --exclude "storage" -av --delete . $APP_PATH/.

cd $APP_PATH || exit

echo "CLEARING CACHE"
php artisan cache:clear

echo "MIGRATING DATABASE"
php artisan migrate:fresh --seed

echo "Ensure the web server can write to the storage and cache directories"
sudo chown -R www-data:www-data $APP_PATH/storage
sudo chmod -R 775 $APP_PATH/storage

echo "Reload PHP & Nginx"
sudo systemctl reload php8.3-fpm
sudo systemctl reload nginx

# If there were stashed changes, apply them back
git stash pop || true
echo "DEPLOYMENT COMPLETE"