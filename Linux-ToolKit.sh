#!/bin/bash

#############################################################################
#     Created By: Mitchell Pemberton (RoSsIsChAmP) Inspired by Eric Dodge   #
#	                        Started 07/13/2017                          #
#############################################################################

#Creates the user interface
echo -e "\033[0;31m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\033[m"
echo -e "\033[0;31m+   _      _                    _______          _   _  ___ _     +\033[m"
echo -e "\033[0;31m+  | |    (_)                  |__   __|        | | | |/ (_) |    +\033[m"
echo -e "\033[0;31m+  | |     _ _ __  _   ___  __    | | ___   ___ | | | ' / _| |_   +\033[m"
echo -e "\033[0;37m+  | |    | | '_ \| | | \ \/ /    | |/ _ \ / _ \| | |  < | | __|  +\033[m"
echo -e "\033[0;37m+  | |____| | | | | |_| |>  <     | | (_) | (_) | | | . \| |  _   +\033[m"
echo -e "\033[0;37m+  |______|_|_| |_|\__,_/_/\_\    |_|\___/ \___/|_| |_|\_\_|\__|  +\033[m"
echo -e "\033[0;37m+                                                                 +\033[m"
echo -e "\033[0;34m+           Created By: Mitchell Pemberton (RoSsIsChAmP)          +\033[m"
echo -e "\033[0;34m+                                                                 +\033[m"
echo -e "\033[0;34m+                             Version 3.0                         +\033[m"
echo -e "\033[0;34m+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\033[m"

read -p "Press enter to continue: "

clear

echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo "+                   Main Menu               +"
echo "+       Choose what you would like to do?   +"
echo "+                                           +"
echo "+    Hashing (Current Working Directory)    +"
echo "+    1. MD5                                 +"
echo "+    2. sha256                              +"
echo "+    3. sha512                              +"
echo "+    Parsing                                +"
echo "+    4. Sudo Audits                         +"
echo "+    5. Login Failures                      +"
echo "+    6. System Users                        +"
echo "+    Hardware Information                   +"
echo "+    7. CPU Information                     +"
echo "+    8. PCI Information                     +"
echo "+    9. RAM Information                     +"
echo "+   10. Bios Information                    +"
echo "+   11. All Hardware Information            +"
echo "+    IPtables Firewall Configuration        +"
echo "+   12. Flush IPtables Configuration        +"
echo "+   13. Show IPtables Configuration         +"
echo "+   14. Secure IPtables Configuration       +"
echo "+    System Information                     +"
echo "+   15. Kernel Version                      +"
echo "+   16. Hostname                            +"
echo "+   17. IP Address                          +"
echo "+   18. MAC Address                         +"
echo "+   19. Check Enabled Services              +"
echo "+   20. Check Disabled Services             +"
echo "+    Drive Wipe                             +"
echo "+   21. Full Drive Wipe                     +"
echo "+                                           +"
echo "+++++++++++++++++++++++++++++++++++++++++++++"

read -p "Please pick a number: " answer

clear

if [ "$answer" == "1" ]; then
#Gets the MD5 hash and the dates modified of the directory 

	find -L -type f -printf '%Tc %p\n' -exec md5sum "{}" \; >> md5sum.md5


	md5sum -c md5sum.md5 >> checklog.md5


	chmod 0444 md5sum.md5


	echo "Files hashed using MD5"

fi


if [ "$answer" == "2" ]; then
#Gets the sha256 hash and the dates modified of the directory 

	find -L -type f -printf '%Tc %p\n' -exec sha256sum "{}" \; >> sha256sum.sha256


	sha256sum -c sha256sum.sha256 >> checklog.sha256


	chmod 0444 sha256sum.sha256


	echo "Files hashed using sha256"

fi

if [ "$answer" == "3" ]; then
#Gets the sha512 hash and the dates modified of the directory 

	find -L -type f -printf '%Tc %p\n' -exec sha512sum "{}" \; >> sha512sum.sha512


	sha512sum -c sha512sum.sha512 >> checklog.sha512


	chmod 0444 sha512sum.sha512
	

	echo "Files hashed using sha512"

fi

if [ "$answer" == "4" ]; then
#Parses for sudo attempts and failures
	echo "Are you on a redhat based system? (y/n)"
	
	read check1
	
	if [ "$check1" == "y" ];then

		sudo echo "There were $(grep -c ' sudo: ' /var/log/secure) attempts to use sudo, $(grep -c ' sudo: .*authentication failure' /var/log/secure) of which failed."
	
	else

		sudo echo "There were $(grep -c ' sudo: ' /var/log/auth.log) attempts to use sudo, $(grep -c ' sudo: .*authentication failure' /var/log/auth.log) of which failed."
	
	fi


fi	

if [ "$answer" == "5" ]; then
#Parses failed logins of all kinds as well as their IPs if they were remote
	echo "Are you on a redhat based system? (y/n)"
	
	read check

	if [ "$check" == "y" ]; then
		 
		 sudo file -r /var/log/secure
		 
		 sudo grep "authentication failure" /var/log/secure | awk '{ print $13 }' | cut -b7-  | sort | uniq -c >> Failed-Logins.txt

	else

		 sudo file -r /var/log/auth.log			
	
		 sudo cat /var/log/auth.log | grep "Failed password for" | sed 's/[0-9]/1/g' | sort -u | tail >> Failed-Logins.txt

	fi

	echo "Failed logins written to file (Failed-Logins.txt) in your CWD"

fi

#Gets the users on the system 
if [ "$answer" == "6" ]; then 

	cat /etc/passwd | grep /bin/bash 

fi

#gets cpu information and prints it to a file
if [ "$answer" == "7" ]; then

	lscpu 

fi

#Lists all the PCI info
if [ "$answer" == "8" ]; then

	lspci

fi

#Lists all RAM info
if [ "$answer" == "9" ]; then

	sudo dmidecode -t memory

fi

if [ "$answer" == "10" ]; then

	sudo dmidecode -t bios

fi

if [ "$answer" == "11" ]; then

	sudo dmidecode >> ALLInfo.txt
	
	echo "All hardware info written to file ALLInfo.txt in your CWD"

fi

#IPtables rules 
if [ "$answer" == "12" ]; then

	sudo iptables -F

fi

if [ "$answer" == "13" ]; then

	sudo iptables -L

fi

#Secure Iptables configuration
if [ "$answer" == "14" ]; then

	#Accepts Established Connections

	sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

	#Sets INPUT accept rules

	#HTTP
	sudo iptables -A INPUT -p tcp --sport 80 -j ACCEPT

	#HTTPS
	sudo iptables -A INPUT -p tcp --sport 443 -j ACCEPT

	#DNS UDP
	sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT

	#DNS
	sudo iptables -A INPUT -p tcp --sport 53 -j ACCEPT

	#DHCP
	sudo iptables -A INPUT -p udp --sport 68 -j ACCEPT

	#Allow loop back
	sudo iptables -I INPUT 1 -i lo -j ACCEPT

	#INPUT drop packets logging
	sudo iptables -N LOGGING

	#Create a new chain called LOGGING
	sudo iptables -A INPUT -j LOGGING

	#All the remaining incoming packets will jump to the LOGGING chain
	sudo iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

	#Finally, drop all the packets that came to the LOGGING chain
	sudo iptables -A LOGGING -j DROP

	#Drop Rules

	#Reject Ping Requests
	sudo iptables -A INPUT -p ICMP --icmp-type 8 -j DROP

	#INPUT Policy set to drop
	sudo iptables -P INPUT DROP



	#Forward Policy set to Drop
	sudo iptables -P FORWARD DROP



	#OUTPUT rules
	sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

	#Sets OUTPUT accept rules

	#HTTP
	sudo iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

	#HTTPS
	sudo iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
	
	#DNS UDP
	sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

	#DNS
	sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

	#DHCP
	sudo iptables -A OUTPUT -p udp --dport 68 -j ACCEPT

	#Allow ICMP Out
	sudo iptables -A OUTPUT -p ICMP --icmp-type 8 -j ACCEPT

	#Allow loop back
	sudo iptables -A OUTPUT -o lo -j ACCEPT

	#OUTPUT drop packets logging
	sudo iptables -N LOGGING

	#Create a new chain called LOGGING
	sudo iptables -A OUTPUT -j LOGGING

	#All the remaining incoming packets will jump to the LOGGING chain
	sudo iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

	#Finally, drop all the packets that came to the LOGGING chain
	sudo iptables -A LOGGING -j DROP

	#Output policy set to drop
	sudo iptables -P OUTPUT DROP	


fi

#Gets Kernel Version of the system
if [ "$answer" == "15" ]; then

	uname -r

fi

#Gets the hostname of the system
if [ "$answer" == "16" ]; then

	cat /etc/hostname

fi

#Gets the IP address of the system
if [ "$answer" == "17" ]; then

	ip a | grep inet

fi

#Gets the MAC Address of the system
if [ "$answer" == "18" ]; then

	ip a | grep ether

fi

#Check enabled services
if [ "$answer" == "19" ]; then

	systemctl list-unit-files | grep enabled | less

fi

#Check disabled services
if [ "$answer" == "20" ]; then

	systemctl list-unit-files | grep disabled | less

fi



#Wiping the entire drive
if [ "$answer" == "21" ]; then	

	echo "What is the path of the drive you want to wipe? (/dev/****) or run (df -h) to see all drive paths"

	read letter

	echo "Are you sure you want to entirely wipe the drive /dev/$letter? This is not reversable. (y/n)"

	read check2	

	if [ "$check2" == "y" ]; then 
	
		dd if=/dev/zero of=/dev/$letter bs=1M
	
	else

		exit 0

	fi

fi
