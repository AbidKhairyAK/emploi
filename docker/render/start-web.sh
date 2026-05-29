#!/usr/bin/env sh

set -eu

mkdir -p \
    bootstrap/cache \
    storage/app/private/livewire-tmp \
    storage/app/public \
    storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views \
    storage/logs

chown -R www-data:www-data bootstrap/cache storage

php artisan package:discover --ansi
php artisan migrate --force

if [ "${RUN_DEMO_SEED:-false}" = "true" ]; then
    php artisan db:seed --force
fi

php artisan config:cache
php artisan route:cache
php artisan view:cache

exec apache2-foreground
