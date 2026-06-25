#!/bin/sh

cd /var/www/wordpress
wp core download --allow-root  # remember what happens when you mount an volume

MYSQL_PASSWORD=$(cat /run/secrets/MYSQL_PASSWORD.txt)
WP_ADMIN_PASSWORD=$(cat /run/secrets/WP_ADMIN_PASSWORD.txt)
WP_USER_PASSWORD=$(cat /run/secrets/WP_USER_PASSWORD.txt)

while ! mariadb -h mariadb -u root -p"${MYSQL_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1;
do 
    echo "Waiting for MariaDB to be ready..." # why we connect as root ? because we need to create the database and the user for wordpress
    sleep 3
done


if [ ! -f  wp-config.php ]
    then
wp config  create --allow-root \
           --dbname=${MYSQL_NAME} \
            --dbuser=${MYSQL_USER} \
            --dbpass=${MYSQL_PASSWORD} \
            --dbhost=mariadb:3306 \
            --path='/var/www/wordpress'
            
wp core install --allow-root \
            --url=${DOMAIN_NAME} --title="Inception" \
            --admin_user=${WP_ADMIN_USER} \
            --admin_password=${WP_ADMIN_PASSWORD} \
            --admin_email=${WP_ADMIN_EMAIL}

wp user create --allow-root \
            ${WP_USER} \
            ${WP_USER_EMAIL} \
            --user_pass=${WP_USER_PASSWORD} \
            --role=author
fi 




exec php-fpm8.2 -F