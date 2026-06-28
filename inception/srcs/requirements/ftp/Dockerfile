FROM debian:bookworm


RUN apt-get update && apt-get install -y \
    vsftpd  && rm -rf /var/lib/apt/lists/*


COPY conf/vsftpd.conf /etc/vsftpd.conf

# if you jail a user in a folder , and he has [write_enable=YES] vsftpd deny and throw an error that why we use allow_writeable_chroot=YES


# a user should be unprivileged to log into the vsftpd 

COPY tools/setup.sh /home/setup.sh
RUN chmod +x /home/setup.sh

EXPOSE 21

ENTRYPOINT [ "/home/setup.sh" ]