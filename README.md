## Purpose

Strangely, Airport cards don't always play well with every type of router. A standard configuration to connect to a wireless network works via DHCP to assign an IP automatically. Some routes, however, don't work well with it, and you need to assign an IP manually. To do this, you usually have to open the Network Preferences, click through a bunch of dialogs, and, well, that sucks. You can also make the changes via the command line.

This script does that for you.

Generally, you need to do this when you connect to a network and get the ! over the Airport icon in the menu bar. That's not always the case, but sometimes it is.

## Use

Enter a command:

dhcp "auto" or "automatic" as an argument sets the DHCP to auto.  
dhcp {IP address} as the argument (e.g. dhcp 192.168.1.13) sets the DHCP to a manual IP address. Generally the IP address would be something like 192.168.1.* where the * is a number between 2 and 255, but it varies depending on your router setup.

You need to type in your user password each time you use this workflow.


### Notes

The command line utility has a tiny bit of lag, so expect to wait a moment before the password box pops up.

No notifications are sent through Alfred. Everything should start working a moment after entering your password.

Alleyoop support.

### Downloading

* Github: https://github.com/shawnrice/alfred2-dhcp-toggle
* Direct download: [ Workflow | https://github.com/shawnrice/alfred2-dhcp-toggle/raw/master/workflows/dhcp-toggle.alfredworkflow ]
