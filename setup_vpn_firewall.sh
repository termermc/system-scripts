#!/bin/bash

# Config
VPNIP='45.79.219.87'
VPNIPv6='2600:3c02::f03c:91ff:fe1c:eca1'

echo "This script will setup a firewall via UFW that will block all traffic that isn't being routed through OpenVPN or LAN. To disable, type \"sudo ufw disable\". Continue? [y/n]"

read yn
if [ $yn != 'y' ]; then
	exit
fi

# Reset rules
sudo ufw --force reset

# Deny all by default
sudo ufw default deny incoming
sudo ufw default deny outgoing

# Allow all traffic through tunnel
sudo ufw allow out on tun0
sudo ufw allow out on eth0 to any port 53,1197 proto udp
sudo ufw allow out on wlan0 to any port 53,1197 proto udp

# Allow all OpenVPN traffic
sudo ufw allow out 1194/udp
sudo ufw allow out 1194/tcp
sudo ufw allow out 1234/udp
sudo ufw allow out 1234/tcp

# Allow LAN connections in and out
sudo ufw allow from 192.168.15.0/24
sudo ufw allow from 192.168.1.0/24
sudo ufw allow from 192.168.0.0/24
sudo ufw allow out on wlan0 to 192.168.15.0/24
sudo ufw allow out on wlan0 to 192.168.1.0/24
sudo ufw allow out on wlan0 to 192.168.0.0/24
sudo ufw allow out on wlp3s0 to 192.168.15.0/24
sudo ufw allow out on wlp3s0 to 192.168.1.0/24
sudo ufw allow out on wlp3s0 to 192.168.0.0/24

# Allow all connections to and from $VPNIP
sudo ufw allow out to "$VPNIP"
sudo ufw allow in from "$VPNIP"
sudo ufw allow out to "$VPNIPv6"
sudo ufw allow in from "$VPNIPv6"

# Enable and print status
sudo ufw enable
sudo ufw status verbose
