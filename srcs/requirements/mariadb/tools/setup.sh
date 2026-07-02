#!/bin/bash


if [ ! -d "/var/lib/mysql/${MYSQL_NAME}" ]; # On Linux systems, /var/lib/ is the standard location for persistent variable data

then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --basedir=/usr > /dev/null 2>&1
# the mysql user should own the files


MYSQL_PASSWORD=$(cat /run/secrets/MYSQL_PASSWORD)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/MYSQL_ROOT_PASSWORD)

if [ -z "$MYSQL_PASSWORD" ]; then
    echo "ERROR: MYSQL_PASSWORD variable is empty!"  >> /home/output.log
    exit 1
fi


echo "launching mariadb in the background"  >> /home/output.log

mysqld_safe --datadir=/var/lib/mysql & # mysqld_safe is a wrapper script that starts the mysqld server and monitors it, restarting it if it crashes. It also provides some additional features, such as logging and error handling.

while ! mysqladmin ping --silent ; do # while repeats only when the command returns success (exit code 0)
echo "mariadb not ready yet..."  >> /home/output.log
sleep 1
done

echo "Creating the Database" >> /home/output.log

mysql -u root  << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_NAME}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_NAME}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Done Creating the Database"  >> /home/output.log

mysqladmin shutdown  # mysqld by default exit after Injecting so we launch at the end in the backgrounds (free port 3306 )
fi

exec mysqld_safe --datadir=/var/lib/mysql  # exec is used so the script replaces itself with the main process (mysqld_safe)