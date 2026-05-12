#!/bin/sh

mysqld_safe --datadir=/var/lib/mysql & 
while ! mysqladmin ping --silent ; do
sleep 1
done
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin shutdown 

mysqld_safe --datadir=/var/lib/mysql