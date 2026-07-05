#!/bin/sh

cd /var/www/wordpress


MYSQL_PASSWORD=$(cat /run/secrets/MYSQL_PASSWORD)
WP_ADMIN_PASSWORD=$(cat /run/secrets/WP_ADMIN_PASSWORD)
WP_USER_PASSWORD=$(cat /run/secrets/WP_USER_PASSWORD)

i = 1
while ! mariadb -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1;
do
	echo "Waiting for MariaDB to be ready..." # why we connect as root ? because we need to create the database and the user for wordpress
	sleep 3
	((i++))
	if ((i > 10)); then
		exit 1
	fi
done

i = 1
while ! redis-cli -h redis -p 6379 ping | grep -i "POng" > /dev/null 2>&1;
do
	echo "Waiting for Redis to be ready..."
	sleep 3
	((i++))
	if ((i > 10)); then
		exit 1
	fi
done


if [ ! -f  wp-config.php ]
	then
wp core download --allow-root  # remember what happens when you mount an volume

chown -R www-data:www-data /var/www/wordpress/

wp config  create --allow-root \
		   --dbname=${MYSQL_NAME} \
			--dbuser=${MYSQL_USER} \
			--dbpass=${MYSQL_PASSWORD} \
			--dbhost=mariadb:3306 \
			--path='/var/www/wordpress'

wp config set  WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --raw --allow-root # --raw remove the "" and treat the value as it is

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

wp plugin install redis-cache --activate --allow-root

wp redis enable --allow-root # completes the setup by generating the physical object cache script (object-cache.php) inside your wp-content folder

fi




exec php-fpm8.2 -F # the engine need to run as root just for a couple seconds until it bind the port then php fpm spawn a pool of processes as www:data user