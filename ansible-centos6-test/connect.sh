#!/bin/sh
exec ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=ansible_test_id_rsa -o user=ansible "$@"
