DATA_PATH= /home/ildaboun/data
SRCS_PATH= ./secrets



all : check_secrets data up

check_secrets :
	@if [ ! -d ${SRCS_PATH} ] ; then \
	echo "[WARNING] : No secrets found ! Try 'make secrets' , fill the files with passwords, then run 'make' "; \
	exit 1;\
	fi

data:
	@echo "Creating volume directories on the host machine..."
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@echo "Directories are ready."

secrets:
	@echo "Creating secrets files on the host machine..."
	@mkdir -p $(SRCS_PATH)
	@touch  $(SRCS_PATH)/FTP_PASSWORD.txt \
			$(SRCS_PATH)/MYSQL_PASSWORD.txt \
			$(SRCS_PATH)/MYSQL_ROOT_PASSWORD.txt \
			$(SRCS_PATH)/WP_ADMIN_PASSWORD.txt \
			$(SRCS_PATH)/WP_USER_PASSWORD.txt

up :
	@echo "Starting Inception infrastructure..."
	docker-compose -f ./srcs/docker-compose.yml up -d --build

down :
	docker-compose -f ./srcs/docker-compose.yml down

fclean :
	@echo "Total wipe of the infrastructure..."
	rm -rf ${DATA_PATH} ${SRCS_PATH}
	docker-compose -f ./srcs/docker-compose.yml down -v --rmi all


re : fclean all


