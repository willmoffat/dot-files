#!/bin/bash

set -eu

i3status -c ~/.dotfiles/i3-wm-status.conf | (
    read line && echo "$line" && while :
        do
            read line
            dat=$(~/.dotfiles/bin/measure-net-speed.bash)
            dat="[{ \"full_text\": \"${dat}\" },"
            echo "${line/[/$dat}" || exit 1
        done)
