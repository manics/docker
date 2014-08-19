#!/bin/sh
# Configure all slaves

# Setup hostname resolution on all nodes
# Docker --link will have setup local aliases on this node, but we need the
# actual container hostname to allow slaves to communicate with each other
# without an explicit link (since links can only be setup one-way).
# Due to https://github.com/docker/docker/issues/2267 /etc/hosts is read-only
# so configure a local DNS server instead.
MASTERS=$(grep 'master' /etc/hosts | cut -f1)
SLAVES=$(grep 'slave' /etc/hosts | cut -f1)
HOSTS="$MASTERS $SLAVES"

IP=$(ip addr show eth0 | sed -nre 's/.*inet ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/p')
MASTER_IPS=
SLAVE_IPS=

function get_remote_dns {
    REMOTE_IP=$(ssh $1 "ip addr show eth0 | sed -nre 's/.*inet ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/p'")
    REMOTE_NAME=$(ssh $1 hostname -f)
}

for host in $MASTERS; do
    get_remote_dns $host
    MASTER_IPS="$MASTER_IPS $REMOTE_IP"
    echo $REMOTE_IP $REMOTE_NAME > /etc/dnsmasq.hosts/$REMOTE_NAME
done

for host in $SLAVES; do
    get_remote_dns $host
    SLAVE_IPS="$SLAVE_IPS $REMOTE_IP"
    echo $REMOTE_IP $REMOTE_NAME > /etc/dnsmasq.hosts/$REMOTE_NAME
done

for host in $MASTERS; do
    scp /etc/dnsmasq.hosts/* $host:/etc/dnsmasq.hosts/
    ssh $host service dnsmasq restart
done

for host in $SLAVES; do
    scp /etc/dnsmasq.hosts/* $host:/etc/dnsmasq.hosts/
    ssh $host service dnsmasq restart
    ssh $host NAMENODE=$IP NAMENODE2=$IP JOBTRACKER=$IP /configure.sh slave
done

NAMENODE=$IP NAMENODE2=$IP JOBTRACKER=$IP MASTERS=$IP SLAVES="$SLAVE_IPS" /configure.sh master namenode namenode2 jobtracker
