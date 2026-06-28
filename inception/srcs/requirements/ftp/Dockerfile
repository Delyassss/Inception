FROM debian:bookworm


RUN apt-get update && apt-get install -y \
    vsftpd  && rm -rf /var/lib/apt/lists/*


RUN sed -i "s|#local_enable=YES|local_enable=YES|" /etc/vsftpd.conf \
&& sed -i "s|#write_enable=YES|write_enable=YES|" /etc/vsftpd.conf \
&& sed -i "s|#chroot_local_user=YES|chroot_local_user=YES|" /etc/vsftpd.conf \ 
&& echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
# if you jail a user in a folder , that folder cant be writable that what why we use the lase cmd


# a user should be unprivileged to log into the vsftpd 

COPY tools/setup.sh /home/setup.sh
RUN chmod +x /home/setup.sh


ENTRYPOINT [ "/home/setup.sh" ]