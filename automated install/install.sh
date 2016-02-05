#!/usr/bin/env bash
# Pi-hole: A black hole for Internet advertisements
# (c) 2015, 2016 by Jacob Salmela
# Network-wide ad blocking via your Raspberry Pi
# http://pi-hole.net
# Blacklists domains
#
# Pi-hole is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.


#Check if we have the function and variable files
if [ ! -f /etc/pihole/pihole.var ]; then
	curl -o $HOME/piholeInstall/pihole.vars https://raw.githubusercontent.com/jacobsalmela/pi-hole/master/automated%20install/pihole.vars
	source $HOME/piholeInstall/pihole.var
else
	source /etc/pihole/pihole.var
fi

if [ ! -f /etc/pihole/pihole.funcs ]; then
	curl -o $HOME/piholeInstall/pihole.funcs https://raw.githubusercontent.com/jacobsalmela/pi-hole/master/automated%20install/pihole.funcs
	source $HOME/piholeInstall/pihole.funcs
else
	source /etc/pihole/pihole.funcs
fi

###########Begin Script
RootCheck

if [ ! -d /etc/pihole ];then
	$SUDO mkdir -p /etc/pihole/
fi

#Display the welcom dialogs
welcomeDialogs

# Just back up the original Pi-hole right away since it won't take long and it gets it out of the way
backupLegacyPihole
# Find interfaces and let the user choose one
chooseInterface
# Let the user decide if they want to block ads over IPv4 and/or IPv6
use4andor6

# Decide what upstream DNS Servers to use
setDNS

# Install and log everything to a file
installPihole | tee $tmpLog

# Move the log file into /etc/pihole for storage
$SUDO mv $tmpLog $instalLogLoc

displayFinalMessage

# Start services
$SUDO service dnsmasq start
$SUDO service lighttpd start