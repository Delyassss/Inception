#!/bin/bash

# i used setup.sh here for security , ENV variable shouldnt be part of the docker inage


FTP_PASSWORD=$(cat /run/secrets/FTP_PASSWORD)

if [ ! -f /etc/ssl/certs/vsftpd.crt ]
	then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/vsftpd.key \
    -out /etc/ssl/certs/vsftpd.crt \
    -subj "/C=MA/ST=BeniMellal/L=Khouribga/O=1337/CN=ildaboun.42.fr"
fi

# -d: Set their home exactly to the shared volume
# -s: Block terminal access for security
# -u 33: Forge the identity to match the web server

if id "${FTP_USER}" > /dev/null 2>&1;
then
	echo "USER ${FTP_USER} already exists"
else

mkdir -p /var/www/wordpress

useradd -d /var/www/wordpress "${FTP_USER}"


echo "$FTP_USER:$FTP_PASSWORD" | chpasswd


usermod -aG www-data "${FTP_USER}"

echo $FTP_USER >> /etc/vsftpd.user_list # allow this user to connect

chmod 777 /var/www/wordpress
fi

echo "Starting ..."
mkdir -p /var/run/vsftpd/empty # vsftpd reates a temporary clone of itself (a worker process) to talk to the visitor but strips all root priv the clone process is located at that path

chmod 600 /etc/vsftpd.conf
# the cloned process only job is to handle the net traffic and authentication
exec vsftpd /etc/vsftpd.conf
