FROM debian:bookworm

RUN apt-get update && apt-get install -y \ 
nginx \
openssl \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl 
# when nginx start as root it takes the cerft and load it into the ram 
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup.sh  /tools/setup.sh

RUN chmod +x /tools/setup.sh

EXPOSE 443
ENTRYPOINT ["/tools/setup.sh"]
