#!/bin/sh

# Set a home-dir so that we can create ssh keys
usermod -d /var/lib/hadoop/hdfs hdfs
usermod -d /var/lib/hadoop/mapred mapred

# Create the server host key
service sshd start && service sshd stop

# All nodes have the same keys
ssh-keygen -t rsa -N "" -f ~root/hadoop.key

for u in root hdfs mapred; do
        d=`eval echo ~$u`
        mkdir -p $d/.ssh
        chmod 700 $d/.ssh
        cp ~root/hadoop.key $d/.ssh/id_rsa
        cp ~root/hadoop.key.pub $d/.ssh/authorized_keys
        (echo -n "* " && cat /etc/ssh/ssh_host_rsa_key.pub) > $d/.ssh/known_hosts
        [ $u != "root" ] && chown -R $u:hadoop $d
done

