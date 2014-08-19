Hadoop 1.2.1 Docker cluster
===========================

This Dockerfile will create an image for trying a simple multi-slave
Hadoop cluster on a Docker host. Use the script below to deploy a cluster.

Note: at present there is only one master which shares the roles of the
namenode, namenode2 and jobtracker.

```
#!/bin/sh

NSLAVES=2
DOMAIN=hadoop.ome
HADOOP_IMAGE=hadoop-cluster

SLAVES=
CIDS=
for n in `seq $NSLAVES`; do
	CID=$(docker run -d --dns=127.0.0.1 -h slave$n.$DOMAIN $HADOOP_IMAGE)
	CNAME=$(docker inspect -f "{{ .Name }}" $CID)
	SLAVES="$SLAVES --link ${CNAME#/}:slave$n"
	CIDS="$CIDS $CID"
done

echo "Slaves: $CIDS"
echo 'To stop all slaves run: docker stop $CIDS'

#docker run -it $SLAVES $HADOOP_IMAGE deploy
docker run -it $SLAVES $HADOOP_IMAGE deploy bash
```
