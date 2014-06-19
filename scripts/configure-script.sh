#!/bin/bash

# Script filter for configuration options

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

# Define the global bundler version.
bundle="com.shawn.patrick.rice.dhcp.toggle";

# Define the data and cache directories for the bundler
data="$HOME/Library/Application Support/Alfred 2/Workflow Data/$bundle"
cache="$HOME/Library/Caches/com.runningwithcrayons.Alfred-2/Workflow Data/$bundle"

# Make the data directory if it doesn't exist
[ ! -d "$data" ] && mkdir "$data"

# Include the workflow handler library
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd -P )/scripts/workflowHandler.sh"

# Remove inside and outside whitespace
arg=$(trim "${1}")


if [[ "$arg" == *" "* ]]; then
	method=$(trim "${arg%% *}")
	param=$(trim "${arg##* }")
else
	method=$(trim "$arg")
fi

if [ -z "$arg" ]; then
	addResult "" "configure-prefixes" "Configure IP Prefixes $method" "Add or Remove Prefixes" "" "yes" ""
	addResult "" "set-default" "Set Default IP Prefix" "Add or Remove Prefixes" "" "yes" ""
	if [ ! -f "$data/sudo" ] || [[ $(cat "$data/sudo" ) != "TRUE" ]]; then
		addResult "" "sudo" "Use this workflow without a password" "This will give you no password sudo access to the \`networksetup\` command." "" "yes" ""
	fi
	getXMLResults
	exit
fi

# Regex for Pattern
pattern="^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\."
pattern+="(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

if [[ "$method" =~ ^d ]]; then
	# Get default
	default=$( cat "$data/default" )
	if [[ "$param" =~ ${pattern} ]]; then	
		addResult "" "default-$param" "Set Default IP Address to $param" "Current default: $default" "" "yes" ""
	else
		addResult "" "" "Please enter a valid IP address prefix (xxx.xxx.xxx)" "Current default: $default" "" "no" ""
	fi
	getXMLResults
	exit
fi

if [[ "$method" =~ ^p ]]; then
	if [[ ! -z "$param" ]]; then
		if [[ "$param" =~ $pattern ]]; then
			prefixes=$(<"$data/prefixes")
			if [[ "$prefixes" == *"$param"* ]]; then
				addResult "" "" "'$param' is already in the prefixes list" "Error: $param is not a valid IP prefix" "" "no" ""	
			else
				addResult "" "add-$param" "Add $param to the prefixes list" "$param" "" "yes" ""
			fi
		else
			addResult "" "" "Add $param to the prefixes list" "Error: $param is not a valid IP prefix" "" "no" ""
		fi
	elif [[ -z "$param" ]]; then
		addResult "" "" "Add a prefix to the list" "Just start typing an IP prefix to add one" "" "no" ""
		for prefix in $( cat "$data/prefixes" ); do
			# Add all other options in the prefixes file
			if [ ! "$prefix" = "$default" ]; then
				addResult "" "remove-$prefix" "Remove $prefix" "" "" "yes" ""
			fi
		done
	fi
	getXMLResults
	exit
fi

addResult "" "" "Here '$method'" "'$method': $param" "" "no" ""
getXMLResults