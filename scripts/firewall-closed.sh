#!/bin/bash

printf '=%.0s' {1..50}
printf "\n\t\tFirewall-Closed\n"
printf '=%.0s' {1..50}

IPTABLES="/sbin/iptables"
printf "\nFlushing rules..."
$IPTABLES -F
printf "\nDenying incoming connections..."
$IPTABLES -I INPUT -p tcp --dport 22 -j ACCEPT
$IPTABLES -I OUTPUT -p tcp --dport 22 -j ACCEPT
# Denying incoming and forwarding
$IPTABLES -P INPUT DROP
$IPTABLES -P FORWARD DROP
$IPTABLES -P OUTPUT DROP

# Allowing localhost
$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A OUTPUT -o lo -j ACCEPT

# Allow established sessions to receive traffic
$IPTABLES -A INPUT -m conntrack --ctstate \
 ESTABLISHED,RELATED -j ACCEPT

$IPTABLES -L -v

printf '=%.0s' {1..50}
printf "\n\t\tProcess finished"

$IPTABLES -A INPUT -p tcp -j LOG -m limit --limit 5/m \
--log-prefix 'DROP IN TCP: '
$IPTABLES -A INPUT -p udp -j LOG -m limit --limit 5/m \
--log-prefix 'DROP IN UDP: '
$IPTABLES -A OUTPUT -p tcp -j LOG -m limit --limit 5/m \
--log-prefix 'DROP OUT TCP: '
$IPTABLES -A OUTPUT -p udp -j LOG -m limit --limit 5/m \
--log-prefix 'DROP OUT UDP: '
