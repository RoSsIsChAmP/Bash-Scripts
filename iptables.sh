#!/bin/bash

# Web server iptables configuration 

# Empty all rules

sudo iptables -t filter -F

sudo iptables -t filter -X



# Block everything by default

sudo iptables -t filter -P INPUT DROP

sudo iptables -t filter -P FORWARD DROP

sudo iptables -t filter -P OUTPUT DROP



# Authorize already established connections

sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED iptables -t filter -A INPUT -i lo -j ACCEPT

sudo iptables -t filter -A OUTPUT -o lo -j ACCEPT



# ICMP (Ping)

sudo iptables -t filter -A INPUT -p icmp -j DROP

sudo iptables -t filter -A OUTPUT -p icmp -j ACCEPT



# DNS

sudo iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT

sudo iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT

sudo iptables -t filter -A INPUT -p tcp --dport 53 -j DROP

sudo iptables -t filter -A INPUT -p udp --dport 53 -j DROP



# HTTP

sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT

sudo iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT



# HTTPS

sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT

sudo iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT


# SSH with brute force prevention

sudo iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT

sudo iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set

sudo iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP


# Drop Null packets
 
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP


# Block XMAS Scan

sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP


