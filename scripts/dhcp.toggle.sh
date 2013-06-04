#!/bin/bash

if [ $# -ne 1 ]; then
	status=`networksetup -getinfo Wi-fi|grep DHCP`
	if [[ "$status" == "Manually Using DHCP Router Configuration" ]]; then
		networksetup -setdhcp Wi-Fi
		echo "DHCP now using an automatic configuration."
		exit
	elif [[ "$status" == "DHCP Configuration" ]]; then
		num=$(php -r 'echo rand(100 , 255);')
		networksetup -setmanualwithdhcprouter Wi-Fi 192.168.10.$num
		echo "DHCP now using a manual configuration with IP 192.168.10.$num";
		exit
	fi
else
	arg="$1"

	if (( [ $arg == "auto" ] ) || ( [ $arg == "automatic" ] )); then
		networksetup -setdhcp Wi-Fi
		echo "DHCP now using an automatic configuration."
		exit
	elif (( [ $arg == "manual" ] ) || ( [ $arg == "man" ] )); then
		num=$(php -r 'echo rand(100 , 255);')
		networksetup -setmanualwithdhcprouter Wi-Fi 192.168.10.$num
		echo "DHCP now using a manual configuration with IP 192.168.10.$num";
		exit
	fi
fi