#!/bin/sh

set -e

: "${DOMAIN_NAME:?DOMAIN_NAME is not set}"
: "${MYSQL_DATABASE:?MYSQL_DATABASE is not set}"
: "${MYSQL_USER:?MYSQL_USER is not set}"
: "${WP_TITLE:?WP_TITLE is not set}"
: "${WP_ADMIN_USER:?WP_ADMIN_USER is not set}"
: "${WP_ADMIN_EMAIL:?WP_ADMIN_EMAIL is not set}"
: "${WP_USER:?WP_USER is not set}"
: "${WP_USER_EMAIL:?WP_USER_EMAIL is not set}"

case "$WP_ADMIN_USER" in
    *[Aa][Dd][Mm][Ii][Nn]*)
        echo "[wordpress] admin username must not contain 'admin'" >&2
        exit 1
        ;;
esac

DB_PASSWORD="$(cat /run/secrets/db_password)"
WP_ADMIN_PASSWORD="$(grep '^WP_ADMIN_PASSWORD=' /run/secrets/credentials | cut -d= -f2-)"
WP_USER_PASSWORD="$(grep '^WP_USER_PASSWORD=' /run/secrets/credentials | cut -d= -f2-)"

if [ ! -f wp-load.php ]; then
    echo "[wordpress] downloading WordPress"
    wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    echo "[wordpress] creating wp-config.php"
    wp config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost=mariadb:3306
fi

if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "[wordpress] installing WordPress"
    wp core install --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
fi

if ! wp user get "$WP_USER" --allow-root > /dev/null 2>&1; then
    echo "[wordpress] creating user ${WP_USER}"
    wp user create "$WP_USER" "$WP_USER_EMAIL" --allow-root \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author
fi

chown -R www-data:www-data /var/www/html

echo "[wordpress] starting php-fpm"
exec "$@"
