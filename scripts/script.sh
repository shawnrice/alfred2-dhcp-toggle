#!/bin/bash

# Regex Pattern for IP matching
pattern="^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

if [[ "$1" =~ ${pattern} ]]; then
	arg="$1"
elif [[ "$1" =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
	arg="$1"
elif [[ $1 =~ ^a ]]; then
	arg="auto"
elif [[ $1 =~ ^c ]]; then
	arg="conf"
else
	arg="man"
fi

status=`networksetup -getinfo Wi-fi|grep Manual`
if [[ "$status" == "Manual Configuration" ]]; then
	current='man'
else
	current='auto'
fi

# Define the bundle id
bundle="com.shawn.patrick.rice.dhcp.toggle";

# Define the data and cache directories
data="$HOME/Library/Application Support/Alfred 2/Workflow Data/$bundle"

# Make the data directory if it doesn't exist
[ ! -d "$data" ] && mkdir "$data"

# Include the workflow handler library
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd -P )/scripts/workflowHandler.sh"

# Built in prefixes
prefixes='  10.0.0'
prefixes+=' 10.0.1'
prefixes+=' 192.168.0'
prefixes+=' 192.168.1'
prefixes+=' 192.168.2'
prefixes+=' 192.1.10'

# Populate the prefixes file if it doesn't exist
if [ ! -f "$data/prefixes" ]; then
	touch "$data/prefixes"
	for prefix in ${prefixes}; do
		echo $prefix >> "$data/prefixes"
	done
fi

# Populate the default if one doesn't exist
[ ! -f "$data/default" ] && echo '10.0.1' > "$data/default"

if [ ${arg} = "conf" ]; then
	addResult "" "configure" "Configure Toggle DHCP" "Add/Remove Prefixes, set defaults" "" "yes" ""
	getXMLResults
	exit
fi

if [[ "$current" = "auto" ]] && [[ "$arg" = "auto" ]]; then
	# If they are trying to set it as auto while already on auto
	addResult "" "" "Toggle DHCP" "You're already using an automatic configuration." "" "no" ""
	addResult "" "configure" "Configure Toggle DHCP" "Add/Remove Prefixes, set defaults" "" "yes" ""
	getXMLResults
	exit
fi

if [[ ${arg} =~ ^a ]]; then
	addResult "" "auto" "Toggle DHCP" "Set DHCP to use an automatic configuration." "" "yes" ""
	getXMLResults
	exit
fi

if [[ ${arg} =~ ${pattern} ]]; then
	base=`expr "$arg" : '\([0-9]*\.[0-9]*\.[0-9]*\)'`
	last=${arg##*.}
	if [[ $last -eq 1 ]]; then
		addResult "" "" "Error: invalid IP" "You cannot set your IP to the router's address" "" "no" ""
		getXMLResults
		exit
	fi
	addResult "$arg" "$arg" "Set DHCP to $arg" "Router will be set to $base.1" "" "yes" ""
	getXMLResults
	exit
fi

# Regex to match IP addresses
pattern="^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$"
if [[ ${arg} =~ ${pattern} ]]; then
	# len=${#arg}
	# This regex pattern could be better
	base=`expr "$arg" : '\([0-9]*\.[0-9]*\.[0-9]*\.\)'`
	addResult "$arg" "$arg" "Set DHCP to $arg" "Router will be set to $base.1" "" "yes" ""
fi

# Get default
default=$( cat "$data/default" )

if [[ ${arg} =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
	# Add default option first
	addResult "$default" "$default.$arg" "Set DHCP to $default.$arg" "Router will be set to $default.1" "" "yes" ""
	for prefix in $( cat "$data/prefixes"); do
		# Add all other options in the prefixes file
		if [ ! "$prefix" = "$default" ]; then
			addResult "$prefix" "$prefix.$arg" "Set DHCP to $prefix.$arg" "Router will be set to $prefix.1" "" "yes" ""
		fi
	done
	addResult "" "configure" "Configure Toggle DHCP" "Add/Remove Prefixes, set defaults" "" "yes" ""
	getXMLResults
	exit
fi

if [[ $current = "man" ]]; then
	addResult "" "auto" "Toggle DHCP" "Set DHCP to use an automatic configuration." "" "yes" ""
fi
# Get a random suffix between 100 and 255
suffix=$(( RANDOM % 155 + 99 ))

# Add default option first
addResult "$default" "$default.$suffix" "Set DHCP to $default.$suffix" "Router will be set to $default.1" "" "yes" ""
for prefix in $( cat "$data/prefixes"); do
	# Add all other options in the prefixes file
	if [ ! "$prefix" = "$default" ]; then
		addResult "$prefix" "$prefix.$suffix" "Set DHCP to $prefix.$suffix" "Router will be set to $prefix.1" "" "yes" ""
	fi
done

addResult "" "configure" "Configure Toggle DHCP" "Add/Remove Prefixes, set defaults" "" "yes" ""
getXMLResults
exit