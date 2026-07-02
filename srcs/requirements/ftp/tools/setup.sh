#!/bin/bash

# i used setup.sh here for security , ENV variable shouldnt be part of the docker inage


FTP_PASSWORD=$(cat /run/secrets/FTP_PASSWORD)


# -d: Set their home exactly to the shared volume
# -s: Block terminal access for security
# -u 33: Forge the identity to match the web server
# -,m smfds

useradd -m "${FTP_USER}"


echo "$FTP_USER:$FTP_PASSWORD" | chpasswd


usermod -aG www-data "${FTP_USER}"



exec vsftpd "/etc/vsftpd.conf"


