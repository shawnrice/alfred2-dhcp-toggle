#!/bin/bash

arg="$1"

if (( [ $arg == "auto" ] ) || ( [ $arg == "automatic" ] )); then
	networksetup -setdhcp Wi-Fi
	exit
elif (( [ $arg == "manual" ] ) || ( [ $arg == "man" ] )); then
	num=$(php -r 'echo rand(100 , 255);')
	networksetup -setmanualwithdhcprouter Wi-Fi 192.168.10.$num
	exit
fi
