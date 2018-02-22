#!/bin/bash

#############################################################################
#     Created By: Mitchell Pemberton (RoSsIsChAmP) Inspired by Eric Dodge   #
#	                        Started 07/13/2017                          #
#############################################################################

#clears the screen
clear

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

#clears the screen
clear

#creates initial main menu
echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo "+                   Main Menu               +"
echo "+       Choose what you would like to do?   +"
echo "+                                           +"
echo "+    1. Hashing                             +"
echo "+    2. Parsing                             +"
echo "+    3. Hardware Information                +"
echo "+    4. IPtables Configuration              +"
echo "+    5. System Information                  +"
echo "+    6. Drive Wipe                          +"
echo "+                                           +"
echo "+++++++++++++++++++++++++++++++++++++++++++++"

read -p "Please pick a number: " answer

clear


if [ "$answer" == "1" ]; then

	#creates hashing menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+               Hashing Menu                +"
	echo "+                                           +"
	echo "+            1. MD5                         +"
	echo "+            2. sha256                      +"
	echo "+            3. sha512                      +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " hashing

	clear

	if [ "$hashing" == "1" ]; then
	#Gets the MD5 hash and the dates modified of the directory 

		find -L -type f -printf '%Tc %p\n' -exec md5sum "{}" \; >> md5sum.md5


		md5sum -c md5sum.md5 >> checklog.md5


		chmod 0444 md5sum.md5


		echo "Files hashed using MD5"

	fi


	if [ "$hashing" == "2" ]; then
	#Gets the sha256 hash and the dates modified of the directory 

		find -L -type f -printf '%Tc %p\n' -exec sha256sum "{}" \; >> sha256sum.sha256


		sha256sum -c sha256sum.sha256 >> checklog.sha256


		chmod 0444 sha256sum.sha256


		echo "Files hashed using sha256"

	fi

	if [ "$hashing" == "3" ]; then
	#Gets the sha512 hash and the dates modified of the directory 

		find -L -type f -printf '%Tc %p\n' -exec sha512sum "{}" \; >> sha512sum.sha512


		sha512sum -c sha512sum.sha512 >> checklog.sha512


		chmod 0444 sha512sum.sha512
	

		echo "Files hashed using sha512"

	fi

fi

if [ "$answer" == "2" ]; then

	#creates parsing menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+                Parsing Menu               +"
	echo "+                                           +"
	echo "+          1. Sudo Audits                   +"
	echo "+          2. Login Failures                +"
	echo "+          3. System Users                  +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " parsing

	clear

	if [ "$parsing" == "1" ]; then
	#Parses for sudo attempts and failures
		echo "Are you on a redhat based system? (y/n)"
	
		read check1
	
		if [ "$check1" == "y" ];then

			sudo echo "There were $(grep -c ' sudo: ' /var/log/secure) attempts to use sudo, $(grep -c ' sudo: .*authentication failure' /var/log/secure) of which failed."
	
		else

			sudo echo "There were $(grep -c ' sudo: ' /var/log/auth.log) attempts to use sudo, $(grep -c ' sudo: .*authentication failure' /var/log/auth.log) of which failed."
	
		fi


	fi	

	if [ "$parsing" == "2" ]; then
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
	if [ "$parsing" == "3" ]; then 

		cat /etc/passwd | grep /bin/bash 

	fi

fi

if [ "$answer" == "3" ]; then

	#creates hardware information menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+               Hardware Menu               +"
	echo "+                                           +"
	echo "+    1. CPU Information                     +"
	echo "+    2. PCI Information                     +"
	echo "+    3. RAM Information                     +"
	echo "+    4. Bios Information                    +"
	echo "+    5. All Hardware Information            +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " hardware

	clear

	#gets cpu information and prints it to a file
	if [ "$hardware" == "1" ]; then

		lscpu 

	fi

	#Lists all the PCI info
	if [ "$hardware" == "2" ]; then

		lspci

	fi

	#Lists all RAM info
	if [ "$hardware" == "3" ]; then

		sudo dmidecode -t memory

	fi

	if [ "$hardware" == "4" ]; then

		sudo dmidecode -t bios

	fi

	if [ "$hardware" == "5" ]; then

		sudo dmidecode >> ALLInfo.txt
	
		echo "All hardware info written to file ALLInfo.txt in your CWD"

	fi

fi

if [ "$answer" == "4" ]; then

	#creates IPtables menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+                IPtables Menu              +"
	echo "+                                           +"
	echo "+    1. Flush Configuration                 +"
	echo "+    2. Show Configuration                  +"
	echo "+    3. Secure Configuration                +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " iptables

	clear

	if [ "$iptables" == "1" ]; then
	
		sudo iptables -F

	fi


	if [ "$iptables" == "2" ]; then

		sudo iptables -L

	fi

	if [ "$iptables" == "3" ]; then


		# Empty all rules

		sudo iptables -t filter -F

		sudo iptables -t filter -X



		# Implicit deny

		sudo iptables -t filter -P INPUT DROP

		sudo iptables -t filter -P FORWARD DROP

		sudo iptables -t filter -P OUTPUT DROP



		# Authorize already established connections

		sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

		sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED iptables -t filter -A INPUT -i lo -j ACCEPT

		sudo iptables -t filter -A INPUT -i lo -j ACCEPT

		sudo iptables -t filter -A OUTPUT -o lo -j ACCEPT



		# ICMP (Ping) if required change DROP to ACCEPT

		sudo iptables -t filter -A INPUT -p icmp -j DROP

		sudo iptables -t filter -A OUTPUT -p icmp -j ACCEPT



		# DNS

		sudo iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT

		sudo iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT

		sudo iptables -t filter -A INPUT -p tcp --dport 53 -j DROP

		sudo iptables -t filter -A INPUT -p udp --dport 53 -j DROP



		# HTTP

		sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT

		sudo iptables -t filter -A INPUT -p tcp --dport 80 -j DROP



		# HTTPS

		sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT

		sudo iptables -t filter -A INPUT -p tcp --dport 443 -j DROP


		# SSH with brute force prevention (sub eth0 with interface name)

		sudo iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT

		sudo iptables -t filter -A INPUT -p tcp --dport 22 -j DROP 



		# Drop Null packets
 
		sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP


		# Block XMAS Scan

		sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

	fi

fi

if [ "$answer" == "5" ]; then

	#creates system information menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+                System Menu                +"
	echo "+                                           +"
	echo "+    1. Kernal Version                      +"
	echo "+    2. Hostname                            +"
	echo "+    3. IP Address                          +"
	echo "+    4. MAC Address                         +"	
	echo "+    5. Check Enabled Services              +"
	echo "+    6. Check Disabled Services             +"
	echo "+                                           +"
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " system

	clear

	#Gets Kernel Version of the system
	if [ "$system" == "1" ]; then

		uname -r

	fi

	#Gets the hostname of the system
	if [ "$system" == "2" ]; then

		cat /etc/hostname

	fi

	#Gets the IP address of the system
	if [ "$system" == "3" ]; then

		ip a | grep inet

	fi

	#Gets the MAC Address of the system
	if [ "$system" == "4" ]; then

		ip a | grep ether

	fi

	#Check enabled services
	if [ "$system" == "5" ]; then

		systemctl list-unit-files | grep enabled | less

	fi

	#Check disabled services
	if [ "$system" == "6" ]; then

		systemctl list-unit-files | grep disabled | less

	fi

fi

if [ "$answer" == "6" ]; then

	#creates drive wipe menu
	echo "+++++++++++++++++++++++++++++++++++++++++++++"
	echo "+              Drive Wipe Menu              +"
	echo "+                                           +"
	echo "+    1. Full Drive Wipe                     +"
	echo "+                                           +"	
	echo "+++++++++++++++++++++++++++++++++++++++++++++"

	read -p "Please pick a number: " drive

	clear

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

fi
