FROM    ajoergensen/baseimage-ubuntu

LABEL	maintainer="Rizal Fauzie Ridwan <rizal@fauzie.my.id>"

ENV     PHP_VERSION=7.2 \
        VIRTUAL_HOST=$DOCKER_HOST \
        PHP_VHOST=$DOCKER_HOST \
        HOME=/var/www/whmcs \
        TZ=Asia/Jakarta \
        WHMCS_SERVER_IP=172.17.0.1 \
        REAL_IP_FROM=172.17.0.0/16 \
        REAL_IP_HEADER=X-Forwarded-For

COPY    build /build

RUN     build/setup.sh && rm -rf /build

COPY    root/ /

RUN     chmod -v +x /etc/my_init.d/*.sh /etc/service/*/run

EXPOSE  2222

VOLUME  /var/www/whmcs
WORKDIR /var/www/whmcs
