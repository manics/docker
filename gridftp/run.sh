#!/bin/sh
if [ -n "$PASSWORD" ] ; then
    echo "gridftp:$PASSWORD" | chpasswd
fi
if [ $# -eq 0 ]; then
    exec /usr/sbin/sshd -eD
else
    exec bash -c "$@"
fi
