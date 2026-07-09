FROM debian:bookworm


RUN apt-get update && apt-get install -y \
    python3 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

COPY conf/ /var/www/html

RUN chown -R www-data:www-data /var/www/html/ && chmod 755 /var/www/html/

# Webserver like nginx or apache runs as a user called www-data, so we give ownership of the file
# if not given ownership, the webserver will not be able to read the file and will return a 403 forbidden error

ENTRYPOINT ["python3" , "-m" , "http.server" , "3000" , "--directory" , "/var/www/html"]
