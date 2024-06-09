#!/bin/bash

echo "Build..."
cd src
# rm -fr vendor
# composer install

echo "Deploy..."
rsync --exclude ".git" -av --delete . $APP_PATH/.

echo "Reload PHP & Nginx"
sudo systemctl reload php8.1-fpm
sudo systemctl reload nginx