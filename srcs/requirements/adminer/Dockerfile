FROM debian:bookworm 

RUN apt-get update && apt-get install -y \
php8.2 \
php8.2-fpm \
php8.2-mysql \ 
wget \
&& rm -rf /var/lib/apt/lists/*


RUN mkdir -p /var/www/html

RUN wget -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v5.3.0/adminer-5.3.0.php

# Give PHP-FPM ownership of the file cuz www-data is the user that runs php-fpm and we want it to be able to read and write to the file , i guess only read is needed but we give it write too just in case
RUN chown -R www-data:www-data /var/www/html && chmod 755 /var/www/html/index.php
# the www-data:www-data is the user and group that runs php-fpm we just give it ownership of the file so it can read and write to it

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /run/php

EXPOSE 9000

ENTRYPOINT ["php-fpm8.2", "-F"]