FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server && rm -rf /var/lib/apt/lists/*

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/

RUN chmod 644 /etc/mysql/mariadb.conf.d/my.cnf
# mariadb throw an error that prevent our own cnf file to be used


RUN mkdir -p /tools

COPY tools/setup.sh /tools/setup.sh
RUN chmod +x /tools/setup.sh

EXPOSE 3306

ENTRYPOINT ["/tools/setup.sh" ]