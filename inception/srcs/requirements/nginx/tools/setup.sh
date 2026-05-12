#!/bin/sh

if [ ! -f /etc/nginx/ssl/nginx.crt ]
then 
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt  \
    -subj "/C=MA/ST=BeniMellal/L=Khouribga/O=42/OU=1337/CN=ildaboun.42.fr/UID=ildaboun"
fi

nginx -g daemon off