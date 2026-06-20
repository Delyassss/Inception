#!/bin/sh
if [ ! -d "/var/lib/mysql/mysql" ]; # On Linux systems, /var/lib/ is the standard location for persistent variable data
then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --basedir=/usr > /dev/null 2>$1

mysqld_safe --datadir=/var/lib/mysql &
 
while ! mysqladmin ping --silent ; do #while repeats only when the command returns success (exit code 0)
sleep 1
done

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
GRANT ALL PRIVILEGES ON ${MYSQL_NAME}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin shutdown  # mysqld by default exit after Injecting so we launch at the end in the backgrounds (free port 3306    )
fi 

exec mysqld_safe --datadir=/var/lib/mysql # exec is used so the script replaces itself with the main process (mysqld_safe