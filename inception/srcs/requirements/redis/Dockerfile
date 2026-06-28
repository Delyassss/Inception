FROM debian:bookworm

# 1. Install the engine
RUN apt-get update && apt-get install -y redis-server




RUN sed -i 's|bind 127.0.0.1|bind 0.0.0.0|' /etc/redis/redis.conf \
    && sed -i 's|daemonize yes|daemonize no|' /etc/redis/redis.conf

# skip the password phase
RUN sed -i 's|protected-mode yes|protected-mode no|' /etc/redis/redis.conf

ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]

