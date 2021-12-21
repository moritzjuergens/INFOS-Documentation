#!/bin/sh

printf '=%.0s' {1..50}
printf "\n\t\tFirewall-Open\n"
printf '=%.0s' {1..50}

IPTABLES="/sbin/iptables"
printf "\n\nResetting default policies...\n"
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT ACCEPT

printf "Resetting NAT policies...\n"
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT ACCEPT

printf "Flushing rules...\n\n"
$IPTABLES -F
$IPTABLES -t nat -F
$IPTABLES -X
$IPTABLES -t nat -X
$IPTABLES -L -v
printf '=%.0s' {1..50}
printf "\n\t\tProcess finished"

$IPTABLES -A INPUT -p tcp -j LOG -m limit --limit 5/m \ 
--log-prefix 'ACCEPT IN TCP: '
$IPTABLES -A INPUT -p udp -j LOG -m limit --limit 5/m \ 
--log-prefix 'ACCEPT IN UDP: '
$IPTABLES -A OUTPUT -p tcp -j LOG -m limit --limit 5/m \ 
--log-prefix 'ACCEPT OUT TCP: '
$IPTABLES -A OUTPUT -p udp -j LOG -m limit --limit 5/m \ 
--log-prefix 'ACCEPT OUT UDP: '

