#!/bin/bash

shopt -s nocasematch
: ${PHP_SESSION_SAVE_HANDLER:="files"}

if [[ $PHP_SESSION_SAVE_HANDLER == "files" ]]
 then
    if [[ ! -d /var/lib/php/sessions ]]; then
        mkdir -p /var/lib/php/sessions
        chown -R app:app /var/lib/php
    fi
	export PHP_SESSION_GC_PROPABILITY=0
 else
	export PHP_SESSION_GC_PROPABILITY=1
fi

# Configure php-fpm pool
mkdir -p  /etc/php/${PHP_VERSION}/fpm/pool.d/
dockerize -template /app/php-fpm-pool.tmpl > /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

# Configure PHP sessions
dockerize -template /app/php-session.tmpl > /etc/php/${PHP_VERSION}/fpm/conf.d/99-sessions.ini

# Set file upload size
dockerize -template /app/php-upload.tmpl > /etc/php/${PHP_VERSION}/fpm/conf.d/99-max-upload.ini
