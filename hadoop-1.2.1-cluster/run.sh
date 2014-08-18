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

getvars SLAVE
SLAVE_IPS="$RET"

if [ $# -lt 1 ]; then
	env
	echo $SLAVE_IPS
	export SLAVE_IPS
	bash
elif [ "$1" = "default" ]; then
	/configure.sh
else
	/configure.sh "$@"
fi

