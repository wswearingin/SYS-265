#!/bin/bash

#creates a new ssh user using $1 parameter
#adds a public key from remote
#removes root ssh

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
	echo "Script must be run as root."
	exit 1
fi

# Ensure new user name supplied
if [ $# -lt 1 ]; then
	echo "Must provide at least 1 argument"
	exit 1
fi

# Disallow root login over SSH
sed -i 's/#\?\(PermitRootLogin\s*\).*$/\1 no/' /etc/ssh/sshd_config

# Create new user and directories
USER = "$1"
useradd -m -d /home/$USER -s /bin/bash $USER
mkdir /home/$USER/.ssh

# Get public key
curl https://github.com/wswearingin/sys-265/linux/public-keys/id_rsa.pub >> /home/$USER/.ssh/authorized_keys

# Set permissions
chmod 700 /home/$USER/.ssh
chmod 600 /home/$USER/.ssh/authorized_keys
chown -R $USER:$USER /home/$USER/.ssh


