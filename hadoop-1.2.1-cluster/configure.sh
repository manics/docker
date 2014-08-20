#!/bin/bash

set -e

#master, namenode, jobtracker, slave
roles="$@"
[ -z "$roles" ] && roles="master slave namenode namenode2 jobtracker"

role_namenode=
role_namenode2=
role_jobtracker=
role_master=
role_slave=

[[ $roles =~ (^|\ )namenode($|\ ) ]] && role_namenode=1
[[ $roles =~ (^|\ )namenode2($|\ ) ]] && role_namenode2=1
[[ $roles =~ (^|\ )jobtracker($|\ ) ]] && role_jobtracker=1
[[ $roles =~ (^|\ )master($|\ ) ]] && role_master=1
[[ $roles =~ (^|\ )slave($|\ ) ]] && role_slave=1


# Are namenode and jobtracker also master?

IP=$(ip addr show eth0 | sed -nre 's/.*inet ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/p')
[ -z "$NAMENODE" ] && NAMENODE=$IP
[ -z "$NAMENODE2" ] && NAMENODE2=$IP
[ -z "$JOBTRACKER" ] && JOBTRACKER=$IP
[ -z "$MASTERS" ] && MASTERS=$IP
[ -z "$SLAVES" ] && SLAVES=$IP

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


if [ -n "$role_namenode" ]; then
	/etc/init.d/hadoop-namenode format
fi

# Distributed, but namenode only:
# http://stackoverflow.com/questions/19779405/hadoop-conf-masters-and-conf-slaves-on-jobtracker
if [ -n "$role_namenode" ]; then
	rm /etc/hadoop/masters /etc/hadoop/slaves
	for addr in $MASTERS; do
		echo $addr >> /etc/hadoop/masters
	done
	for addr in $SLAVES; do
		echo $addr >> /etc/hadoop/slaves
	done
fi

# Actually start-dfs and start-mapred can be run from the master node
# but does master mean any/all master nodes, or only one of them?
# This suggests namenode and jobtracker are different:
# http://hadoop.apache.org/docs/r1.2.1/cluster_setup.html
if [ -n "$role_namenode" ]; then
	su - hdfs -c /usr/sbin/start-dfs.sh
	# I think this uses the HDFS API, so can be run anywhere:
	hadoop-setup-hdfs.sh --mapreduce-user=mapred
fi

if [ -n "$role_jobtracker" ]; then
	su - mapred -c /usr/sbin/start-mapred.sh
fi

# Needs to correspond to a system user otherwise you'll see lots of non-fatal
# warnings in the logs
if [ -n "$role_namenode" ]; then
	useradd omero
	hadoop-create-user.sh omero
fi

echo $IP
