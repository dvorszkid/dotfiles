#!/usr/bin/env bash

configfile="/etc/firewall.conf"

call_both()
{
    iptables "$@"
    ip6tables "$@"
}

firewall_flush()
{
	echo "flushing"
	call_both -F
	call_both -X
}

firewall_setpolicies()
{
	echo "setting default policies to $1"
	call_both -P OUTPUT $1
	call_both -P INPUT $1
	call_both -P FORWARD $1
}

firewall_start()
{
	firewall_flush
	firewall_setpolicies "DROP"
	echo "ACCEPT policy for OUTPUT chain"
	call_both -P OUTPUT ACCEPT

	echo "dropping invalid packages"
	call_both -A INPUT -m conntrack --ctstate INVALID -j DROP

	echo "accepting related, estabilished and loopback"
	call_both -I INPUT -i lo -j ACCEPT
	call_both -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

	echo "creating chains to hide firewall"
	call_both -N REJECT_DEFAULT
	call_both -A REJECT_DEFAULT -p tcp -j REJECT --reject-with tcp-reset
	iptables -A REJECT_DEFAULT -p udp -j REJECT --reject-with icmp-port-unreachable

	echo "creating burst limited port chain"
	call_both -N openports_limit
	echo -n " - ports:"
	for i in "${BURST_LIMITED[@]}";
	do
		echo -n " $i"
		call_both -A openports_limit -p tcp --dport $i -m limit --limit 3/m -j RETURN
		call_both -A openports_limit -p udp --dport $i -m limit --limit 3/m -j RETURN
		call_both -A openports_limit -p tcp --dport $i -j REJECT_DEFAULT
		call_both -A openports_limit -p udp --dport $i -j REJECT_DEFAULT
	done
	echo

	echo "creating opened ports chain"
	call_both -N openports
	echo -n " - TCP ports:"
	for i in "${ACCEPT_TCP[@]}";
	do
		echo -n " $i"
		call_both -A openports -p tcp --dport $i -m conntrack --ctstate NEW -j ACCEPT
	done
	echo
	echo -n " - UDP ports:"
	for i in "${ACCEPT_UDP[@]}";
	do
		echo -n " $i"
		call_both -A openports -p udp --dport $i -j ACCEPT
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
	call_both -N icmp_security
	iptables -A icmp_security -p icmp --icmp-type echo-request -m limit --limit 3/m -j ACCEPT
	call_both -A icmp_security -p icmp -j DROP

	# TCP Flags: SYN, ACK, FIN, RST, URG, PSH
	echo "creating TCP security chain"
	call_both -N tcp_security

	# filter bad guys against nmap like port scans
	call_both -A tcp_security -p tcp -m conntrack --ctstate NEW -m recent --name portscan --set
	call_both -A tcp_security -p tcp -m conntrack --ctstate NEW -m recent --name portscan --update --seconds 60 --hitcount 100 -j REJECT_DEFAULT

	# null scan
	call_both -A tcp_security -p tcp --tcp-flags ALL NONE -j REJECT_DEFAULT

	# xmas scan
	call_both -A tcp_security -p tcp --tcp-flags ALL ALL -j REJECT_DEFAULT
	call_both -A tcp_security -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j REJECT_DEFAULT
	call_both -A tcp_security -p tcp --tcp-flags SYN,FIN SYN,FIN -j REJECT_DEFAULT
	call_both -A tcp_security -p tcp --tcp-flags SYN,RST SYN,RST -j REJECT_DEFAULT

	# fin scan
	call_both -A tcp_security -p tcp --tcp-flags FIN,ACK FIN -j REJECT_DEFAULT

	# bad flags
	call_both -A tcp_security -p tcp --tcp-flags ALL FIN,URG,PSH -j REJECT_DEFAULT
	call_both -A tcp_security -p tcp --tcp-flags SYN,RST SYN,RST -j REJECT_DEFAULT
	call_both -A tcp_security -p tcp --tcp-flags FIN,RST SYN,RST -j REJECT_DEFAULT
	call_both -A tcp_security -p tcp --tcp-flags ACK,URG URG -j REJECT_DEFAULT
	call_both -A tcp_security -p tcp --tcp-flags ACK,PSH PSH -j REJECT_DEFAULT

	# NEW without SYN?
	call_both -A tcp_security -p tcp --syn -m conntrack ! --ctstate NEW -j REJECT_DEFAULT
	call_both -A tcp_security -p tcp ! --syn -m conntrack --ctstate NEW -j REJECT_DEFAULT

	# limit new connection requests (off: does not work for server-like use cases)
	#call_both -A tcp_security -p tcp --syn -m limit --limit 3/s -j RETURN
	#call_both -A tcp_security -p tcp --syn -j REJECT_DEFAULT

	echo "compiling INPUT chain"
	echo " - adding ICMP security"
	call_both -A INPUT -p icmp -j icmp_security
	echo " - adding TCP security"
	call_both -A INPUT -p tcp -j tcp_security
	echo " - adding burst limitation"
	call_both -A INPUT -j openports_limit
	echo " - adding opened ports"
	call_both -A INPUT -j openports
	echo " - adding REJECT_DEFAULT to hide firewall"
	call_both -A INPUT -j REJECT_DEFAULT
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

