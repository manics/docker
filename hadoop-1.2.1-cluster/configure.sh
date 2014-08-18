#!/bin/bash

#master, namenode, jobtracker, slave
role=
# Are namenode and jobtracker also master?

IP=$(ip addr show eth0 | sed -nre 's/.*inet ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/p')
NAMENODE=$IP
NAMENODE2=$IP
JOBTRACKER=$IP
SLAVES=$IP

service sshd start

source /etc/hadoop/hadoop-env.sh

# Defaults to user mr, rpm creates user mapred
hadoop-setup-conf.sh --jobtracker-host=$JOBTRACKER --namenode-host=$NAMENODE --secondarynamenode-host=$NAMENODE2 --mapreduce-user=mapred

# Clients may connect through a proxy, don't use this internally
sed -i.bak -re 's/<\/configuration>/\
	<property>\
	<name>hadoop.rpc.socket.factory.class.default<\/name>\
	<value>org.apache.hadoop.net.StandardSocketFactory<\/value>\
	<final>true<\/final>\
	<\/property>\n\
<\/configuration>/' /etc/hadoop/core-site.xml

# Set a home-dir so that we can create ssh keys
usermod -d /var/lib/hadoop/hdfs hdfs
usermod -d /var/lib/hadoop/mapred mapred

for u in hdfs mapred; do
	d=`eval echo ~$u`
	mkdir $d/.ssh
	chmod 700 $d/.ssh
	cp hadoop.key $d/.ssh/id_rsa
	cp hadoop.key.pub $d/.ssh/authorized_keys
	(echo -n "* " && cat /etc/ssh/ssh_host_rsa_key.pub) > $d/.ssh/known_hosts
	chown -R $u $d
done



#if [ $role = namenode ]; then
	/etc/init.d/hadoop-namenode format
#fi

# Distributed, but namenode only:
# http://stackoverflow.com/questions/19779405/hadoop-conf-masters-and-conf-slaves-on-jobtracker
#if [ $role = namenode ]; then
	echo "$IP" > /etc/hadoop/masters
	echo "$SLAVES" > /etc/hadoop/slaves
#fi

# Actually start-dfs and start-mapred can be run from the master node
# but does master mean any/all master nodes, or only one of them?
# This suggests namenode and jobtracker are different:
# http://hadoop.apache.org/docs/r1.2.1/cluster_setup.html
#if [ $role = namenode ]; then
	su - hdfs -c /usr/sbin/start-dfs.sh
	# I think this uses the HDFS API, so can be run anywhere:
	hadoop-setup-hdfs.sh --mapreduce-user=mapred
#fi

#if [ $role = jobtracker ]; then
	su - mapred -c /usr/sbin/start-mapred.sh
#fi

# Only run once, so might as well use the namenode
#if [ $role = namenode ]; then
	hadoop-create-user.sh omero
#fi

echo $IP
