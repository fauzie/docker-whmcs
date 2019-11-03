#!/bin/bash

shopt -s nocasematch
: ${APP_PASSWORD:=""}
: ${SSH_PUBLIC_KEY:=""}

mkdir -p /var/www/.ssh
mkdir -p /var/run/sshd
usermod -d /var/www app
usermod -s /bin/bash app

# update SSH Configuration
sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -ri 's/^#?RSAAuthentication\s+.*/RSAAuthentication yes/' /etc/ssh/sshd_config
sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -ri 's/^#?AuthorizedKeysFile\s+.*/AuthorizedKeysFile \/var\/www\/.ssh\/authorized_keys/' /etc/ssh/sshd_config
sed -ri 's/^#HostKey \/etc\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/' /etc/ssh/sshd_config
sed -ri 's/^#ListenAddress\s0+.*/ListenAddress 0\.0\.0\.0/' /etc/ssh/sshd_config
sed -ri 's/^#UsePAM\s+.*/UsePAM yes/' /etc/ssh/sshd_config
sed -ri "s/^#Port\s+.*/Port ${SSH_PORT}/" /etc/ssh/sshd_config

if [[ $SSH_PUBLIC_KEY != "" ]]
then
    sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    echo "${SSH_PUBLIC_KEY}" > /var/www/.ssh/authorized_keys
    chmod 600 /var/www/.ssh/authorized_keys
elif [[ $APP_PASSWORD != "" ]]
then
    echo "app:${APP_PASSWORD}" | chpasswd
else
    echo "app:whmcsapp" | chpasswd
fi

# FIX ssh permission
chown -R app:app /var/www/.ssh
chmod 700 /var/www/.ssh

# add ssh to upstart
if [[ -f /etc/service/sshd/down ]]; then
    rm -f /etc/service/sshd/down
fi
