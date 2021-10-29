#!/bin/bash
# ======== Username Configuration ========
# Get old and new username
read -p "Enter the old user of the server: " OLDUSERNAME
read -p "Enter the new user of the server: " USERNAME

# # Get group
# read -p "Enter the new group of the server: " GROUP

# Get password
read -p "Enter the new password of the server: " PASSWD

# ======== Hostname Configuration ========
# Get hostname
read -p "Enter the hostname of the server: " HOSTNAME


# Excute configuration command
usermod -l $USERNAME -d /home/$USERNAME -m $OLDUSERNAME
groupmod -n $USERNAME $OLDUSERNAME
usermod --password $(echo $PASSWD | openssl passwd -1 -stdin) $USERNAME
hostnamectl set-hostname $HOSTNAME

echo "==========================="