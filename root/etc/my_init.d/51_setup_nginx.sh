#!/bin/bash

shopt -s nocasematch
: ${GENERATE_DEFAULT_VHOST:="true"}
: ${WORKER_PROCESSES:="auto"}
: ${CHOWN_WWWDIR:="TRUE"}
: ${NGINX_CLIENT_MAX_BODY_SIZE:="50M"}
: ${NGINX_ACCESS_LOG:="off"}
CONFDIR="/etc/nginx/conf.d"


grep -q "@@WORKER_PROCESSES@@" /etc/nginx/nginx.conf

if [[ $? -eq 0 ]] && [[ -w /etc/nginx/nginx.conf ]]
 then
	sed -i "s|@@WORKER_PROCESSES@@|$WORKER_PROCESSES|" /etc/nginx/nginx.conf
fi

grep -q "@@NGINX_CLIENT_MAX_BODY_SIZE@@" /etc/nginx/nginx.conf

if [[ $? -eq 0 ]] && [[ -w /etc/nginx/nginx.conf ]]
 then
	sed -i "s|@@NGINX_CLIENT_MAX_BODY_SIZE@@|$NGINX_CLIENT_MAX_BODY_SIZE|" /etc/nginx/nginx.conf
fi

grep -q "@@NGINX_ACCESS_LOG@@" /etc/nginx/nginx.conf

if [[ $? -eq 0 ]] && [[ -w /etc/nginx/nginx.conf ]]
 then
	sed -i "s|@@NGINX_ACCESS_LOG@@|$NGINX_ACCESS_LOG|" /etc/nginx/nginx.conf
fi

# chown'ning the entire /var/www may not be desireable
[ -w "${HOME}" ] || CHOWN_WWWDIR="FALSE"

if [[ $CHOWN_WWWDIR == "TRUE" ]]
 then
	chown -R app:app $HOME
fi

# Configure default site
COUNT=`find $CONFDIR/ -type f | wc -l`
if [[ $COUNT -eq 0 ]] && [[ $GENERATE_DEFAULT_VHOST != "false" ]]
 then
        dockerize -template /app/default-vhost.tmpl > $CONFDIR/default.conf
fi

# Make sure the app user is able to write to nginx directories
mkdir -p /var/www/logs
chown -R app:app /var/log/nginx /var/cache/nginx /var/www/logs
