#!/bin/bash

set -eu
cd "$(dirname "$0")"

i3status -c i3status.conf | (
    read line && echo "$line" && while :
        do
            read line
            dat=$(./measure-net-speed.bash)
            dat="[{ \"full_text\": \"${dat}\" },"
            echo "${line/[/$dat}" || exit 1
        done)
