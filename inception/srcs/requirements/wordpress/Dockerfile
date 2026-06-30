FROM debian:bookworm

RUN apt-get update -y && apt-get install -y \
    php-fpm \
    php-mysql \
    mariadb-client \
    wget
    redis-tools \
    wget

RUN wget -O wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# the bin path is to make our wp cli tool easy to call like wp ...

RUN mkdir -p /run/php && mkdir -p /var/www/wordpress
# php-fpm create and write to a small text file called a PID file in the above directory to track its process ID

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
# the -i to edit in place not in the terminal


COPY ./tools/setup.sh /usr/local/bin/tools/setup.sh
RUN chmod +x /usr/local/bin/tools/setup.sh

ENTRYPOINT ["/usr/local/bin/tools/setup.sh"]
