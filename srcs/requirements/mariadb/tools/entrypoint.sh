#!/bin/sh
set -e

: "${MYSQL_DATABASE:?MYSQL_DATABASE is not set}"
: "${MYSQL_USER:?MYSQL_USER is not set}"

DB_PASSWORD="$(cat /run/secrets/db_password)"
DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"

chown -R mysql:mysql /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "[mariadb] empty data directory: creating system tables"
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "[mariadb] first start: creating database and user"
    mariadbd --bootstrap << SQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
DROP USER IF EXISTS ''@'localhost';
DROP DATABASE IF EXISTS test;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
FLUSH PRIVILEGES;
SQL
fi

echo "[mariadb] starting server"
exec "$@"
