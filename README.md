This project has been created as part of the 42 curriculum by ildaboun

Inception

Description

This project is a system administration exercise designed to broaden my knowledge of system architecture, Docker, and Docker Compose. The goal is to virtualize a complete, secure infrastructure using multiple isolated containers operating on a dedicated bridge network.

The architecture strictly adheres to the 1337/42 guidelines. The core infrastructure consists of:

NGINX: Operating as the sole entry point via TLSv1.2/v1.3 on port 443.

WordPress + php-fpm: Running the website logic, isolated from the web server.

MariaDB: Handling the backend database, strictly isolated from external networks.

To complete the Bonus requirements, the following services are fully integrated:

vsftpd: Secure FTP access to the WordPress volume with strict Chroot jailing and TLS encryption.

Redis: In-memory data structure store used as an object cache for WordPress to optimize performance.

Adminer: A lightweight, single-PHP-file database management tool (alternative to phpMyAdmin).

Static Website: A custom static webpage hosted independently within the infrastructure.

cAdvisor (Service of Choice): A Google daemon providing deep, real-time monitoring of container resource usage and performance characteristics.

All services are built entirely from scratch using minimal Debian/Alpine images. No pre-made DockerHub application images were used.

Instructions

1. Generate the Secrets (Required)
To comply with security requirements, absolutely no passwords or sensitive .env files are pushed to this repository. Before starting the infrastructure, you must generate the secret files locally:
make secrets
Note: This will create empty .txt files inside srcs/secrets/. You must manually open these files and enter your desired passwords before proceeding.

2. Build and Launch the Infrastructure
Once your secrets are configured, launch the architecture:
make
This command will create the necessary host volumes (/home/ildaboun/data) and start the Docker Compose network in the background.

3. Access the Services

Website: https://ildaboun.42.fr

Admin Panel: https://ildaboun.42.fr/wp-admin

Adminer: https://ildaboun.42.fr/adminer (Requires routing setup in NGINX)

Static Website: https://ildaboun.42.fr/resume (Requires routing setup in NGINX)

cAdvisor: Access via the designated host port (e.g., http://ildaboun.42.fr/cadvisor)

FTP Access: Connect securely via lftp using the credentials provided in your secrets folder.

Example command: lftp -u <your_ftp_username> localhost (The client will prompt for your password and negotiate the TLS handshake).

4. Shut Down and Clean Up

To stop the containers without losing data: make down

To completely wipe the infrastructure (containers, volumes, networks, images, and local data folders): make fclean

Resources

Official Documentation: Docker Compose V2, NGINX configuration guidelines, MariaDB secure installation docs, and cAdvisor GitHub documentation.

AI Assistance: Artificial Intelligence (LLMs) was strictly used as an interactive debugging tool to troubleshoot legacy vsftpd TLS session reuse collisions, diagnose Linux kernel OverlayFS privilege escalation errors