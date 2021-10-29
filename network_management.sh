#!/bin/bash
#
# ======== Network Configuration ========
# Creates a backup
# Changes dhcp from 'yes' to 'no'
sed -i "s/dhcp4: yes/dhcp4: no/g" /etc/netplan/00-installer-config.yaml
# Retrieves the NIC information
nic=`cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | tail -1`

# IP pattern
IP_SLASH_PATTERN="([0-9]{1,3}[\.]){3}[0-9]{1,3}\/[0-9]{1,2}"
IP_PATTERN="([0-9]{1,3}[\.]){3}[0-9]{1,3}"

# Ask and check input on network configuration
read -p "Enter the static IP of the server in CIDR notation: " STATICIP
if [[ $STATICIP =~ $IP_SLASH_PATTERN ]] ; 
then
  echo "IP pattern good"
else
  echo "Wrong IP pattern"
  exit 1
fi

read -p "Enter the IP of your gateway: " GATEWAY
if [[ $GATEWAY =~ $IP_PATTERN ]] ; 
then
  echo "Gateway pattern good"
else
  echo "Wrong Gateway pattern"
  exit 1
fi

read -p "Enter the IP of preferred nameservers (seperated by a coma if more than one): " NAMESERVER
if [[ $NAMESERVER =~ $IP_PATTERN ]] ; 
then
  echo "DNS pattern good"
else
  echo "Wrong DNS pattern"
  exit 1
fi

echo
cat > /etc/netplan/00-installer-config.yaml <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $nic
      addresses:
        - $STATICIP
      gateway4: $GATEWAY
      nameservers:
          addresses: [$NAMESERVER]
EOF
netplan apply
echo "==========================="
echo