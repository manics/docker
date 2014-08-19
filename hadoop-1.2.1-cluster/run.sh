#!/bin/bash

#set -x

# e.g.
# SLAVE1_PORT_8020_TCP_ADDR=127.0.0.1
# SLAVE2_PORT_8020_TCP_ADDR=127.0.0.2
# etc

function getvars {
	RET=
	prefix="$1"
	suffix="_PORT_8020_TCP_ADDR"
	let i=0
	while true; do
		let i++
		VNAME="${prefix}${i}${suffix}"
		VVAL=$(eval echo \$${prefix}${i}${suffix})
		if [ -n "$VVAL" ]; then
			echo "$VNAME = $VVAL"
			[ -z "$RET" ] && RET=$VVAL || RET="$RET $VVAL"
		else
			break
		fi
	done
}

IP=$(ip addr show eth0 | sed -nre 's/.*inet ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*/\1/p')
getvars MASTER
MASTER_IPS="$RET"
getvars SLAVE
SLAVE_IPS="$RET"

if [ $# -lt 1 ]; then
	exec /tail_hadoop_logs.sh
elif [ "$1" = "bash" ]; then
	env
	service sshd start
	echo IP: $IP
	echo Master IPs: $MASTER_IPS
	echo Slave IPs: $SLAVE_IPS
	export IP MASTER_IPS SLAVE_IPS
	shift
	exec bash "$@"
elif [ "$1" = "deploy" ]; then
	/deploy-configure.sh
	if [ $# -gt 1 ]; then
		shift
		exec bash "$@"
	fi
else
	exec "$@"
fi
