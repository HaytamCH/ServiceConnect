#!/bin/sh
set -eu

# Check if users table already exists (skip import if DB was already initialized)
TABLE_EXISTS=$(mysql -u root -p"$DB_PASSWORD" -h "$DB_HOST" "$DB_DATABASE" \
  -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_DATABASE' AND table_name='users';" 2>/dev/null || echo "0")

if [ "$TABLE_EXISTS" = "0" ]; then
    echo "Importing database dump..."
    mysql -u root -p"$DB_PASSWORD" -h "$DB_HOST" "$DB_DATABASE" < /var/www/html/serviceconnect_dump.sql
    echo "Dump imported."
fi

php artisan migrate --force
php artisan db:seed --class=Database\\Seeders\\ProductionSeeder --force
