#! /bin/bash

set +eu

sync
i3lock -c 990000

# Sometimes it's not possible to restart after this command:
# systemctl suspend
# Maybe because of https://bugzilla.kernel.org/show_bug.cgi?id=104771
#   Fixed in https://github.com/torvalds/linux/commit/406f992
#   Kernel 4.7

# Note(wdm) This requires hackery such as:
# sudo chmod 666 /sys/power/state
# echo $1 > /sys/power/state

systemctl $1
# Note(wdm) Capslock as Control. TODO(wdm) Why do I need this again?
sleep 3
setxkbmap -option ctrl:nocaps
