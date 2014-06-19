DHCP Toggle
===

An Alfred 2 Workflow.

Find it on:

- Packal: [DHCP Toggle](http://www.packal.org/workflow/dhcp-toggle)
- Github: [DHCP Toggle Repository](https://github.com/shawnrice/alfred2-dhcp-toggle)

####Short Description
Set your DHCP Settings via Alfred.

####Long Description
[DHCP Toggle](http://www.packal.org/workflow/dhcp-toggle) allows you to alter your DHCP settings between a manual and an automatic configuration. When you set an automatic configuration, which is normal, your computer will receive an IP address directly from the router that you're connected to. If you choose manual, you have the option of setting your own IP address. If the router's IP address is `10.0.1.1`, then you'll be able to get an IP with a prefix of `10.0.1` and a suffix between `2` and `255`. If the IP address is already used, then you'll have to try again. [DHCP Toggle](http://www.packal.org/workflow/dhcp-toggle) will also set your router address to the IP prefix that you use, followed by `1`, which is always reserved for the router.

You can use this when your Internet connection is weak, or if a router is clogged, or if, for some random reason, the router doesn't like you connecting with an automatic IP address (the original need for this workflow).

####Commands
`dhcp <arg>`

Available arguments:

* _None_: defaults to your default IP prefix + random number 2–255
* Switch to auto: `auto`
* IP Address: `10.0.1.192`
* Number: 2–255, i.e. `32`
* Configure `c`

####Configuration

######Default Prefix
You can set a default prefix, the first three numbers of an IP address, which will be given precedence over the other available prefixes. If you just type a three-digit number (between 2–255), then it will set your IP address to DEFAULTIP.NUMBER.

######IP Prefixes
You can set a list of prefixes that you commonly use, and those will appear in the script filter to choose easily. If no prefixes file is found, then the following list will be populated:

````
10.0.0
10.0.1
192.168.0
192.168.1
192.168.2
192.1.10
````

You can add and remove from this list from the configuration option.

######Passwordless Execution (`sudo`)
If you would prefer to use this workflow without a password, you can select the option to add a record to your sudoers file. The script will add the line

````$USER ALL=NOPASSWD:/usr/sbin/networksetup````

to your `/etc/sudoers` file, where `$USER` is your username; so, the `$USER` will now be able to execute the command `networksetup` without needing to enter a password. The script checks the syntax with `visudo` to make sure that it doesn't bork your `/etc/sudoers` file. So, it's safe.

####Demo
![alt text](https://raw.githubusercontent.com/shawnrice/alfred2-dhcp-toggle/master/images/dhcp-toggle.gif "DHCP Demo")

####Credit
Thanks for version 2.0 goes to Pryley \([Github](https://github.com/pryley) | [Alfred Forum](http://www.alfredforum.com/user/4689-pryley/)\) who opened a pull request for the added features and contributed some code.

####Issues
Please report coding issues on the [Github issue queue](https://github.com/shawnrice/alfred2-dhcp-toggle/issues?state=closed).
Other support should be posted on the [Alfred Forum thread](http://www.alfredforum.com/topic/2579-toggle-dhcp-ip-address-fixes-internet-connectivity-issues/).

####Support
While never necessary, feel free to [buy me a beer](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=rice@shawnrice.com).