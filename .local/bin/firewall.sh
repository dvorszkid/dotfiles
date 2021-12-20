#!/usr/bin/env bash

configfile="/etc/firewall.conf"

firewall_flush()
{
	echo "flushing"
	iptables -F
	iptables -X
	ip6tables -F
	ip6tables -X
}

firewall_setpolicies()
{
	echo "setting default policies to $1"
	iptables -P OUTPUT $1
	iptables -P INPUT $1
	iptables -P FORWARD $1
	ip6tables -P OUTPUT $1
	ip6tables -P INPUT $1
	ip6tables -P FORWARD $1
}

firewall_start()
{
	firewall_flush
	firewall_setpolicies "DROP"
	echo "ACCEPT policy for OUTPUT chain"
	iptables -P OUTPUT ACCEPT

	echo "blocking IPv6 connections"
	ip6tables -P OUTPUT DROP
    ip6tables -P INPUT DROP
    ip6tables -P FORWARD DROP
    ip6tables -A INPUT -i lo -j ACCEPT

	echo "dropping invalid packages"
	iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

	echo "accepting related, estabilished and loopback"
	iptables -I INPUT -i lo -j ACCEPT
	iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

	echo "creating chains to hide firewall"
	iptables -N REJECT_DEFAULT
	iptables -A REJECT_DEFAULT -p tcp -j REJECT --reject-with tcp-reset
	iptables -A REJECT_DEFAULT -p udp -j REJECT --reject-with icmp-port-unreachable

	echo "creating burst limited port chain"
	iptables -N openports_limit
	echo -n " - ports:"
	for i in "${BURST_LIMITED[@]}";
	do
		echo -n " $i"
		iptables -A openports_limit -p tcp --dport $i -m limit --limit 3/m -j RETURN
		iptables -A openports_limit -p udp --dport $i -m limit --limit 3/m -j RETURN
		iptables -A openports_limit -p tcp --dport $i -j REJECT_DEFAULT
		iptables -A openports_limit -p udp --dport $i -j REJECT_DEFAULT
	done
	echo

	echo "creating opened ports chain"
	iptables -N openports
	echo -n " - TCP ports:"
	for i in "${ACCEPT_TCP[@]}";
	do
		echo -n " $i"
		iptables -A openports -p tcp --dport $i -m conntrack --ctstate NEW -j ACCEPT
	done
	echo
	echo -n " - UDP ports:"
	for i in "${ACCEPT_UDP[@]}";
	do
		echo -n " $i"
		iptables -A openports -p udp --dport $i -j ACCEPT
	done
	echo
	echo -n " - TCP ports (from $LOCAL_SUBNET):"
	for i in "${ACCEPT_LOCAL_TCP[@]}";
	do
		echo -n " $i"
		iptables -A openports -p tcp --dport $i -s $LOCAL_SUBNET -m conntrack --ctstate NEW -j ACCEPT
	done
	echo
	echo -n " - UDP ports (from $LOCAL_SUBNET):"
	for i in "${ACCEPT_LOCAL_UDP[@]}";
	do
		echo -n " $i"
		iptables -A openports -p udp --dport $i -s $LOCAL_SUBNET -j ACCEPT
	done
	echo

	echo "creating ICMP security chain"
	iptables -N icmp_security
	iptables -A icmp_security -p icmp --icmp-type echo-request -m limit --limit 3/m -j ACCEPT
	iptables -A icmp_security -p icmp -j DROP

	# TCP Flags: SYN, ACK, FIN, RST, URG, PSH
	echo "creating TCP security chain"
	iptables -N tcp_security

	# filter bad guys against nmap like port scans
	iptables -A tcp_security -p tcp -m conntrack --ctstate NEW -m recent --name portscan --set
	iptables -A tcp_security -p tcp -m conntrack --ctstate NEW -m recent --name portscan --update --seconds 60 --hitcount 100 -j REJECT_DEFAULT

	# null scan
	iptables -A tcp_security -p tcp --tcp-flags ALL NONE -j REJECT_DEFAULT

	# xmas scan
	iptables -A tcp_security -p tcp --tcp-flags ALL ALL -j REJECT_DEFAULT
	iptables -A tcp_security -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j REJECT_DEFAULT
	iptables -A tcp_security -p tcp --tcp-flags SYN,FIN SYN,FIN -j REJECT_DEFAULT
	iptables -A tcp_security -p tcp --tcp-flags SYN,RST SYN,RST -j REJECT_DEFAULT

	# fin scan
	iptables -A tcp_security -p tcp --tcp-flags FIN,ACK FIN -j REJECT_DEFAULT

	# bad flags
	iptables -A tcp_security -p tcp --tcp-flags ALL FIN,URG,PSH -j REJECT_DEFAULT
	iptables -A tcp_security -p tcp --tcp-flags SYN,RST SYN,RST -j REJECT_DEFAULT
	iptables -A tcp_security -p tcp --tcp-flags FIN,RST SYN,RST -j REJECT_DEFAULT
	iptables -A tcp_security -p tcp --tcp-flags ACK,URG URG -j REJECT_DEFAULT
	iptables -A tcp_security -p tcp --tcp-flags ACK,PSH PSH -j REJECT_DEFAULT

	# NEW without SYN?
	iptables -A tcp_security -p tcp --syn -m conntrack ! --ctstate NEW -j REJECT_DEFAULT
	iptables -A tcp_security -p tcp ! --syn -m conntrack --ctstate NEW -j REJECT_DEFAULT

	# limit new connection requests (off: does not work for server-like use cases)
	#iptables -A tcp_security -p tcp --syn -m limit --limit 3/s -j RETURN
	#iptables -A tcp_security -p tcp --syn -j REJECT_DEFAULT

	echo "compiling INPUT chain"
	echo " - adding ICMP security"
	iptables -A INPUT -p icmp -j icmp_security
	echo " - adding TCP security"
	iptables -A INPUT -p tcp -j tcp_security
	echo " - adding burst limitation"
	iptables -A INPUT -j openports_limit
	echo " - adding opened ports"
	iptables -A INPUT -j openports
	echo " - adding REJECT_DEFAULT to hide firewall"
	iptables -A INPUT -j REJECT_DEFAULT
}

firewall_stop()
{
	firewall_flush
	firewall_setpolicies "ACCEPT"
}

firewall_block()
{
	firewall_flush
	firewall_setpolicies "DROP"
}

source $configfile
echo "*** Loaded config: $configfile"

case "$1" in
start)
	echo "*** Starting firewall ..."
	firewall_start
	;;
stop)
	echo "*** Stopping firewall ..."
	firewall_stop
	;;
restart)
	echo "*** Restarting firewall ..."
	firewall_stop
	firewall_start
	;;
block)
	echo "*** Blocking all connections ..."
	firewall_block
	;;
*)
	echo "Usage: $0 ( start | stop | restart | block )"
	exit 1
	;;
esac

echo "Done."

