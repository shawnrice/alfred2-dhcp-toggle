#!/bin/bash
#
# Define the bundle id
bundle="com.shawn.patrick.rice.dhcp.toggle";

# Define the data and cache directories
data="$HOME/Library/Application Support/Alfred 2/Workflow Data/$bundle"

if [ $1 = "auto" ]; then
	if [ -f "$data/sudo" ] && [[ $(cat "$data/sudo") == "TRUE" ]]; then
		sudo networksetup -setdnsservers Wi-Fi empty && sudo networksetup -setdhcp Wi-Fi
	else 
		script="/usr/sbin/networksetup -setdnsservers Wi-Fi empty && /usr/sbin/networksetup -setdhcp Wi-Fi"
		osascript -e "do shell script \"$script\" with administrator privileges"
	fi
	echo "DHCP is now configured automatically"
	exit
fi

# Regex Pattern for IP matching
pattern="^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
# If the argument is an IP address
if [[ $1 =~ $pattern ]]; then
	# Get the base of the IP address for use with the router
	base=`expr "$1" : '\([0-9]*\.[0-9]*\.[0-9]*\)'`
	if [ -f "$data/sudo" ] && [[ $(cat "$data/sudo") == "TRUE" ]]; then
		sudo networksetup -setdnsservers Wi-Fi ${base}.1 && sudo networksetup -setmanual Wi-Fi $1 255.255.255.0 ${base}.1
	else
		script="/usr/sbin/networksetup -setdnsservers Wi-Fi ${base}.1 && /usr/sbin/networksetup -setmanual Wi-Fi $1 255.255.255.0 ${base}.1"
		osascript -e "do shell script \"$script\" with administrator privileges"
	fi
	echo "IP : ${1}"
	echo "Subnet : 255.255.255.0"
	echo "Router : ${base}.1"
	exit
fi

if [ $1 = "sudo" ]; then
	script=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd -P )"/scripts/add-sudo.sh"
	osascript -e "do shell script quoted form of \"$script\" with administrator privileges"
	exit
fi

### These next commands invoke the extra script filter for configuration
if [ $1 = "configure" ]; then
	script='tell application "Alfred 2" to run trigger "configure" in workflow "com.shawn.patrick.rice.dhcp.toggle" with argument ""'
	osascript -e "$script"
	exit
fi

if [ $1 = "configure-prefixes" ]; then
	script='tell application "Alfred 2" to run trigger "configure" in workflow "com.shawn.patrick.rice.dhcp.toggle" with argument "p "'
	osascript -e "$script"
	exit
fi
if [ $1 = "set-default" ]; then
	script='tell application "Alfred 2" to run trigger "configure" in workflow "com.shawn.patrick.rice.dhcp.toggle" with argument "d "'
	osascript -e "$script"
	exit
fi

### The remaining arguments are for setting configuration

# Regex Pattern for IP Prefix
pattern="^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

if [[ $1 =~ ^default ]]; then
	arg=${1#default-}
	if [[ $arg =~ $pattern ]]; then
		echo $arg > "$data/default"
		echo "Default IP prefix is now '$arg'"
		exit
	else
		echo "ERROR: invalid IP prefix"
		exit 1
	fi
fi

if [[ $1 =~ ^remove ]]; then
	arg=${1#remove-}
	prefixes=$(<"$data/prefixes")
	prefixes=$(echo ${prefixes} | sed 's|'"$arg"'||g')
	rm "$data/prefixes" && touch "$data/prefixes"
	for prefix in ${prefixes}; do
		echo $prefix >> "$data/prefixes"
	done
	echo "Removing '$arg' from prefixes list"
	exit
fi

if [[ $1 =~ ^add ]]; then
	arg=${1#add-}
	prefixes=$(<"$data/prefixes")
	if [[ "$prefixes" == *"$arg"* ]]; then
		echo "'$arg' is already in the prefixes list"
		exit 1
	else
		prefixes+=" $arg"
		rm "$data/prefixes" && touch "$data/prefixes"
		for prefix in ${prefixes}; do
			echo $prefix >> "$data/prefixes"
		done
		echo "Added '$arg' to the prefixes list"
		exit
	fi
fi

echo "This script should not have been called."
exit 1