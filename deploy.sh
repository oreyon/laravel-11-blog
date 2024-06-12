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

# chmod +x deploy.sh

# Continuous Integration
echo "Build..."
cd $APP_PATH
# chown -R $(whoami):$(whoami) $APP_PATH
# chmod 755 $APP_PATH

git stash
git fetch --all
git reset --hard origin/main  
git pull origin $ENV_BRANCH # Pull the latest changes from the repository

# chown -R root:root $APP_PATH
# chmod 755 $APP_PATH

rm -rf vendor
# composer install --no-dev --optimize-autoloader
composer update --no-dev --optimize-autoloader

echo "NPM INSTALL"
npm install
echo "NPM BUILD"
npm run build

# Ensure the web server can write to the storage and cache directories
sudo chown -R www-data:www-data $APP_PATH/storage
sudo chown -R www-data:www-data $APP_PATH/bootstrap/cache
sudo chmod -R 775 $APP_PATH/storage
sudo chmod -R 775 $APP_PATH/bootstrap/cache

echo "Test..."
php artisan test

# Continuous Deployment
echo "Deploy..."
rsync --exclude ".git" --exclude "storage" -av --delete . $APP_PATH/.
# sudo chown -R www-data:www-data $APP_PATH/storage

cd $APP_PATH || exit

echo "Clear cache..."
php artisan cache:clear

echo "Database Migration..."
php artisan migrate --force


echo "Reload PHP & Nginx"
sudo systemctl reload php8.3-fpm
sudo systemctl reload nginx

# If there were stashed changes, apply them back
git stash pop || true