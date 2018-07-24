FROM alpine:edge

# At the moment, Dante is only available on testing repository
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories &&\
    apk --no-cache add dante-server

COPY ./files/etc/sockd.conf /etc/sockd.conf
COPY ./files/usr/local/sbin/sockuseradd /usr/local/sbin/sockuseradd

# Dante is configured to use this directory for logs
RUN mkdir /var/log/sockd

# Set up permissions
RUN chmod 644 /etc/sockd.conf &&\
    chmod 755 /usr/local/sbin/sockuseradd

# Uncomment this to set up user accounts allowed to use proxy
# This command is also directly available inside the container
#RUN sockuseradd sockuser-1 password &&\
#    sockuseradd sockuser-2 password &&\
#    sockuseradd sockuser-3 password

EXPOSE 1080/tcp
EXPOSE 1080/udp

# Preventing container from immediately exiting
CMD sockd -D && sh
