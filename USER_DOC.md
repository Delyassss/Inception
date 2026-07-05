User Documentation (USER_DOC)

Welcome to the Inception infrastructure. This guide is designed for end-users, content managers, and basic administrators to operate the website, manage content, and perform simple troubleshooting without needing deep technical knowledge of Docker or Linux.

1. Quick Start Guide

To turn the entire website and all background services (like the database and cache) on or off, you only need to use the make commands in the main terminal.

To turn everything ON: Open your terminal in the root folder (where the Makefile is) and type:

make


Note: If you receive a warning about "No secrets found," you must first run make secrets and fill in the newly created text files with passwords before starting the server.

To gracefully turn everything OFF: If you need to shut down the server for maintenance, type:

make down


All your data (WordPress posts, themes, database records) is perfectly safe and will remain exactly as you left it when you turn the server back on.

To completely WIPE the server: WARNING! This deletes all WordPress posts, users, and the entire database. It resets everything to a factory-new state.

make fclean


2. Accessing the Website

Once the infrastructure is running via make, you can access your services through any standard web browser.

The Main WordPress Site

URL: https://ildaboun.42.fr

Note: Your browser will likely display a "Warning: Potential Security Risk Ahead" or "Your connection is not private." This is perfectly normal! The server uses a self-signed security certificate. Click Advanced and then Accept the Risk and Continue to view the site securely.

The Administration Panel

URL: https://ildaboun.42.fr/wp-admin

Login: Use the Admin Username and Password you set inside your secrets folder (specifically WP_ADMIN_PASSWORD.txt).

Note: For security reasons, the username cannot contain the word "admin."

3. Bonus Services Access

If you have the bonus features enabled, you can access them via the following routes:

Database Management (Adminer): https://ildaboun.42.fr/adminer (Use your MariaDB credentials to log in).

Static Website: https://ildaboun.42.fr/resume (A secondary, non-WordPress site).

Server Monitoring (cAdvisor): http://ildaboun.42.fr/cadvisor (Provides real-time graphs of server health).

File Transfer (FTP)

You can directly upload or download files to the WordPress folder using an FTP client like lftp or FileZilla.

Open your terminal or FTP software.

Connect to ildaboun.42.fr on port 21.

Use the username ftpuser (or the one you configured) and the password from FTP_PASSWORD.txt.

Example command: lftp -u <your_username> ildaboun.42.fr

4. Basic Checks & Troubleshooting

If the website is not loading, follow these steps:

Is the server running?
Open the terminal and type docker compose -f ./srcs/docker-compose.yml ps. You should see several services (nginx, wordpress, mariadb) listed with a status of Up.

Are the passwords correct?
If you cannot log into the WordPress Admin Panel, check the text files inside the secrets folder to ensure you are using the correct, up-to-date passwords.

Did the database save?
If you create a post, run make down, and then run make again, your post should still be there. If the site asks you to reinstall WordPress, it means your local data folders were deleted.