#!/bin/bash

# Define the bundle id
bundle="com.shawn.patrick.rice.dhcp.toggle"

# Define the data and cache directories
data="$HOME/Library/Application Support/Alfred 2/Workflow Data/$bundle"

line="$USER ALL=NOPASSWD:/usr/sbin/networksetup"
if [ -n "$line" ]; then 
	sudo cp /etc/sudoers /tmp/sudoers.tmp
	sudo bash -c "echo $line >> /tmp/sudoers.tmp"
	sudo visudo -c -f /tmp/sudoers.tmp
	if [ "$?" -eq "0" ]; then
		sudo mv /tmp/sudoers.tmp /etc/sudoers
		echo "You can now use the command networksetup without a password"
		echo "TRUE" > "$data/sudo"
		exit
	else
		sudo rm /tmp/sudoers.tmp
		echo "Error: something went wrong adding to the sudoers file. Please do so manually."
		echo "FALSE" > "$data/sudo"
		exit
	fi
fi