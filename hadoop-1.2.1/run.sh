#!/bin/bash

INIT=0
if [ $# -lt 1 ]; then
	env
	INIT=1
	CMD=start
else
	CMD="$1"
fi

IP=$(ip addr show eth0 | sed -nre 's/.*inet ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

if [ $INIT -eq 1 ]; then
	rm -r /var/log/hadoop/*
	#sed -i.bak "s/<\/configuration>/\
	#	<property><name>dfs.namenode.rpc-address<\/name>\
	#	<value>$IP:8020<\/value><\/property>\n\
#<\/configuration>/" /etc/hadoop/hdfs-site.xml

	sed -i.bak "s/hdfs:\/\/localhost:8020/hdfs:\/\/$IP:8020/" \
		/etc/hadoop/core-site.xml
fi

/etc/init.d/hadoop-datanode $CMD
/etc/init.d/hadoop-namenode $CMD
/etc/init.d/hadoop-tasktracker $CMD
/etc/init.d/hadoop-jobtracker $CMD

if [ $INIT -eq 1 ]; then
	echo $IP
	#sleep 5
	#tail -F /var/log/hadoop/*/*.log
	bash
fi
