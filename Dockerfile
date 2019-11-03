FROM    ajoergensen/baseimage-ubuntu

LABEL	maintainer="Rizal Fauzie Ridwan <rizal@fauzie.my.id>"

ENV     PHP_VERSION=7.3 \
        VIRTUAL_HOST=$DOCKER_HOST \
        HOME=/var/www/whmcs \
        PUID=1000 \
        PGID=1000 \
        TZ=Asia/Jakarta \
        WHMCS_SERVER_IP=172.17.0.1 \
        REAL_IP_FROM=172.17.0.0/16 \
        SSH_PORT=2222

COPY    build /build

RUN     build/setup.sh && rm -rf /build

COPY    root/ /

RUN     chmod -v +x /etc/my_init.d/*.sh /etc/service/*/run

EXPOSE  2222

VOLUME  /var/www/whmcs
WORKDIR /var/www/whmcs
