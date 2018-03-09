#! /bin/bash

set -eu

MB=10
SIZE="${MB}M"
FILE=/tmp/$SIZE.bin
HOST=mserver1

dd if=/dev/urandom of=$FILE bs=1048576 count=$MB
scp $FILE $HOST:$FILE
