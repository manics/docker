#!/bin/sh

while [ $(ls /var/log/hadoop/*/*.log 2>&1 | wc -l) -lt 2 ]; do
        date
        sleep 10;
done

sleep 10
tail -f /var/log/hadoop/*/*.log
