#!/bin/sh

cd /var/www/wordpress
wp core download --allow-root 

if [ ! -f  wp-config.php ]
    then
wp config  create --allow-root \
           --dbname=${DB_NAME} \
            --dbuser=${MYSQL_USER} \
            --dbpass=${MYSQL_PASSWORD} \
            --dbhost=mariadb:3306
            
wp core install --allow-root \
            --url=ildaboun.42.fr --title="Inception" \
            --admin_user=${WP_ADMIN_USER} \
            --admin_password=${WP_ADMIN_PASSWORD} \
            --admin_email=${WP_ADMIN_EMAIL}

wp user create --allow-root \
            ${WP_USER} \
            ${WP_USER_EMAIL} \
            --user_pass=${WP_USER_PASSWORD} \
            --role=author
fi 




php-fpm8.2 -F