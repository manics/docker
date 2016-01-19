#!/bin/sh
if [ -n "$PASSWORD" ] ; then
    echo "gridftp:$PASSWORD" | chpasswd
fi
exec /usr/sbin/sshd -eD
