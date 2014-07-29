#!/bin/bash

env

IP=$(ip addr show eth0 | sed -nre 's/.*inet ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

sed -i.bak "s/<\/configuration>/\
	<property><name>dfs.namenode.rpc-address<\/name>\
	<value>$IP:8020<\/value><\/property>\n\
<\/configuration>/" /etc/hadoop/hdfs-site.xml

sed -i.bak "s/hdfs:\/\/localhost:8020/hdfs:\/\/$IP:8020/" \
	/etc/hadoop/core-site.xml

/etc/init.d/hadoop-datanode start
/etc/init.d/hadoop-namenode start
/etc/init.d/hadoop-tasktracker start
/etc/init.d/hadoop-jobtracker start

bash
