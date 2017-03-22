#! /bin/bash

set +eu

cmd="$1"

case "$cmd" in
    suspend)
        level='freeze'
        ;;
    hibernate)
        level='disk'
        ;;
    *)
        i3-nagbar -t warning -m "Unknown level $cmd"
        exit -1
        ;;
esac

sync
i3lock -c 990000 &

# Sometimes it's not possible to restart after this command:
# systemctl $cmd
# Maybe because of https://bugzilla.kernel.org/show_bug.cgi?id=104771
#   Fixed in https://github.com/torvalds/linux/commit/406f992
#   Kernel 4.7
# I'm running vmlinuz-4.8.0-41-generic - and still have the problem.

# Note(wdm) This requires hackery such as:
# sudo chmod 666 /sys/power/state # See writeable_syspower.*
echo $level > /sys/power/state

# Note(wdm) Capslock as Control. TODO(wdm) Why do I need this again?
sleep 3
setxkbmap -option ctrl:nocaps
