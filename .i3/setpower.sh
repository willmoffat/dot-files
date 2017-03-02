#! /bin/bash

set +eu

sync
i3lock -c 990000

# Sometimes it's not possible to restart after this command:
# systemctl suspend

# Note(wdm) This requires hackery such as:
# sudo chmod 666 /sys/power/state
echo $1 > /sys/power/state

# Note(wdm) Capslock as Control. TODO(wdm) Why do I need this again?
sleep 3
setxkbmap -option ctrl:nocaps
