Developer Documentation (DEV_DOC)

This document provides technical details on the architecture, setup, and deployment of the Inception infrastructure. It is intended for system administrators and developers maintaining or evaluating this project.

1. Prerequisites

To deploy this architecture, the host machine (Debian VM) must have the following installed:

Docker Engine (V20.10+)

Docker Compose Plugin (V2 syntax: docker compose, not docker-compose)

Make (If missing on a fresh Debian VM, run sudo apt update && sudo apt install make -y)

OpenSSL (For TLS certificate generation inside the NGINX container)

2. Secrets Management & Security

Non-sensitive routing and configuration data (usernames, domain names, emails) should be stored in a .env file located in the ./srcs/ directory.

Here is the required .env blueprint:

# ----------------------------------------------------
# DOMAIN NAME
# ----------------------------------------------------
DOMAIN_NAME=ildaboun.42.fr

# ----------------------------------------------------
# MARIADB SETTINGS
# ----------------------------------------------------
MYSQL_NAME=ildaboun_db
MYSQL_USER=ildaboun

# ----------------------------------------------------
# WORDPRESS ADMIN SETTINGS
# ----------------------------------------------------
WP_ADMIN_USER=ildaboun_admin
WP_ADMIN_EMAIL=ildaboun@student.1337.ma

# ----------------------------------------------------
# WORDPRESS REGULAR USER SETTINGS
# ----------------------------------------------------
WP_USER=ildaboun_user
WP_USER_EMAIL=ildaboun@student.1337.ma

# ----------------------------------------------------
# FTP SETTINGS
# ----------------------------------------------------
FTP_USER=ildaboun_ftp

To strictly adhere to security guidelines, no passwords, credentials, or .env files are tracked in this Git repository.

Instead, this project utilizes Docker Secrets mapped to local text files.

The developer must run make secrets prior to deployment.

This creates the ./secrets/ directory and generates empty .txt placeholder files.

The developer must manually populate these files with secure passwords.

Docker Compose mounts these files directly into the containers at /run/secrets/, ensuring the passwords are never exposed as system environment variables (which are vulnerable to docker inspect).

3. Makefile Reference

The Makefile serves as the primary task runner for the infrastructure. It uses the following rules:

make / make all: The default goal. It verifies secrets exist (check_secrets), creates necessary host directories (data), and launches the containers (up).

make secrets: Generates the empty .txt files for passwords.

make check_secrets: A pre-flight safety check that aborts the build if the secrets directory is missing, preventing container crash-loops.

make data: Runs mkdir -p to ensure the host mount directories exist before Docker attempts to bind them.

make up: Executes docker compose -f ./srcs/docker-compose.yml up -d --build.

make down: Gracefully stops the containers without destroying data.

make fclean: The nuclear option. Stops all containers, completely wipes all Docker Images (--rmi all), removes volumes, and requires sudo to forcefully delete the persistent host data folders and the secrets folder.

make re: Executes fclean followed by all.

4. Data Persistence & Volumes

Docker containers are ephemeral by nature (OverlayFS). To prevent data loss when containers are recreated, two persistent bind mounts are established:

/home/ildaboun/data/mariadb: Binds to /var/lib/mysql inside the database container. This ensures all WordPress configurations, users, and posts survive a restart.

/home/ildaboun/data/wordpress: Binds to /var/www/wordpress inside the WordPress, NGINX, and FTP containers. This allows NGINX to serve the static assets, PHP-FPM to execute the backend logic, and vsftpd to grant secure file transfer access to the webroot.

Note: Deleting these host directories will result in complete amnesia for the infrastructure.

5. Docker Compose Commands for Debugging

If you need to debug the infrastructure without the Makefile, the following V2 commands are useful:

View live logs for all services: docker compose -f ./srcs/docker-compose.yml logs -f

View logs for a specific service (e.g., NGINX): docker compose -f ./srcs/docker-compose.yml logs -f nginx

Check container health and status: docker compose -f ./srcs/docker-compose.yml ps

Open an interactive shell inside a running container (e.g., MariaDB): docker exec -it mariadb sh