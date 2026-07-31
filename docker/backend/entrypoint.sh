#!/bin/sh
set -eu

php artisan config:cache
php artisan event:cache
php artisan view:cache

exec "$@"
