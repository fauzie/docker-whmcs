Docker WHMCS
============

Ready to use docker image for WHMCS environment.

**Please note: Use your own WHMCS package and map to volume /var/www/whmcs**

Features
--------

* Using latest php version 7.2
* Ioncube loader ready
* Nginx server configuration for WHMCS
* Installed default cron for WHMCS (all task include ticket import)
* Custom mapping volume for WHMCS installation at `/var/www/whmcs`
* SSH login with password or public key on port `2222`
* Host SSL Enabled (please map your letsencrypt or other valid certificate)

Installation
------------

First you need to `docker pull fauzie/docker-whmcs:latest` in your docker host. Create `docker-compose.yml` and specify your environment or use one from this repository.

**Required Environment**

- `VIRTUAL_HOST` : URL for your WHMCS installation
- `WHMCS_SERVER_IP` : Required to validate your WHMCS licence (use your docker host public IP address)
- `APP_PASSWORD` : Specify user `app` password for SSH login
- `SSH_PUBLIC_KEY` : or use public key for SSH login, if this specified password login will disabled automatically

**Additional Environment**

- `TZ` : php config `date.timezone`, default Asia/Jakarta
- `WORKER_PROCESSES`: Nginx worker proccess, default auto to use total of your CPU
- `NGINX_CLIENT_MAX_BODY_SIZE`: Nginx limit max upload size, default 50MB
- `PHP_SESSION_SAVE_HANDLER`: php session save handler e.g: "redis", default "files"
- `PHP_SESSION_SAVE_PATH`: php session save path, default if save handler files is `/var/lib/php/sessions`
- `PHP_UPLOAD_MAX_FILESIZE`: max upload size limit on php, default same as Nginx
- `PHP_POST_MAX_SIZE`: php post max size
- `PUID` - Changes the uid of the app user, default 911
- `PGID` - Changes the gid of the app group, default 911
- `SMTP_HOST` - Change the SMTP relay server used by ssmtp (sendmail)
- `SMTP_USER` - Username for the SMTP relay server
- `SMTP_PASS` - Password for the SMTP relay server
- `SMTP_PORT` - Outgoing SMTP port, default 587
- `SMTP_SECURE` - Does the SMTP server requires a secure connection, default TRUE if SMTP_USER is set.
- `SMTP_TLS` - Use STARTTLS, default TRUE (if SMTP_TLS is FALSE and SMTP_SECURE is true, SMTP over SSL will be used)
- `SMTP_MASQ` - Masquerade outbound emails using this domain, default empty

Ports
-----

- `443`: Nginx virtualhost SSL enabled
- `2222` : For remote SSH login

Email
-----

If you need to send mail and cannot use SMTP directly, ssmtp is installed to provide `/usr/bin/sendmail` and is configured using the `SMTP_` variables.

If SMTP_USER is not set, unauthenticated SMTP will be used and SSL/TLS is disabled.

# Local WHMCS Development

## WHMCS Dev License
As long as you have an active WHMCS license, you can reach out to WHMCS Support and get a free dev License to use for your local development.
This Docker setup makes sure you can use it across different machines since the valid IP will be the same. Make sure not to change the Hostname across machines or your dev license will become invalid and needs to be reiussed manually.

## How to run it
In docker-compose[-local].yml change `/your/path/to/whmcs:/var/www/whmcs` to a directory with your whmcs install e.g. `./../whmcs-local/public:/var/www/whmcs`

Start your containers by running

```console
foo@bar:~$ docker-compose up
```

You can then access the container on http://localhost/. By default it maps to Port 80 which can be changed in the docker-compose.yml.
Add whmcs.test (or whatever hostname you choose) to your hosts file pointing to 127.0.0.1 to use http://whmcs.test for local development.

## Using Mailhog for E-Mail testing
In docker-compose-local.yml we've added a third container running mailhog and configured the whmcs container to use it as their outgoing SMPT Server. The whmcs container is based on ajoergensen/baseimage-ubuntu and includes ssmtp which can be configured using the ENV Variables mentioned above.
With this configuration all WHMCS E-mails will automatically be captured by mailhog. No configuration within WHMCS necessary, since the php mail() function will rely on the container settings.

Start your containers with mailhog by specifying the compose file for local development. Or just rename it to docker-compose.yml if thats all you want to do.

```console
foo@bar:~$ docker-compose -f docker-compose-local.yml up
```

You can then access the mailhog webinterface on http://localhost:8025
