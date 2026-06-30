FROM debian:bookworm

RUN apt-get update && apt-get install -y /
	redis-server && rm -rf /var/lib/apt/lists/*


RUN sed -i 's|bind 127.0.0.1|bind 0.0.0.0|' /etc/redis/redis.conf /
&&  sed -i 's|daemonize yes|daemonize no|' /etc/redis/redis.conf /
&&  sed -i 's|protected-mode yes|protected-mode no|' /etc/redis/redis.conf
# redis by default deny access if the user is not local like from diff network


RUN mkdir -p /var/run/redis.pid


ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]