#!/bin/bash

printf '=%.0s' {1..50}
printf "\n\t\tFirewall-Standard\n"
printf '=%.0s' {1..50}

IPTABLES="/sbin/iptables"

printf "\nFlushing rules..."
$IPTABLES -F

# Denying incoming and forwarding
$IPTABLES -P INPUT DROP
$IPTABLES -P FORWARD DROP
$IPTABLES -P OUTPUT DROP

printf "\nDenying incoming connections..."
$IPTABLES -I INPUT -p tcp --dport 22 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp -m tcp -m multiport \
--dports 20,22,53,80,443 -j ACCEPT
$IPTABLES -A OUTPUT -p udp --dport 53 -j ACCEPT

# Allowing localhost
$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A OUTPUT -o lo -j ACCEPT

# Allow established sessions to receive traffic
$IPTABLES -A INPUT -m conntrack --ctstate \
ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A OUTPUT -m conntrack --ctstate \
ESTABLISHED,RELATED -j ACCEPT

$IPTABLES -L -v

printf '=%.0s' {1..50}
printf "\n\t\tProcess finished"
