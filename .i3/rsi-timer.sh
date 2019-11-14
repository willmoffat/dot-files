#! /bin/sh

# This script is started by every i3 start. Make sure we are the only one running.
killall --older-than 5s rsi-timer.sh 2> /dev/null

while : ; do
  sleep 40m
  i3-nagbar -m 'Strech!' -t warning
done

