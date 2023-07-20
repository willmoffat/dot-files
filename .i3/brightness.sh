#! /bin/bash

# Use DCC/CI to set the external monitor brightness. Hardcoded for now.

set -eu

delta="$1"

curr=$(/usr/bin/ddccontrol -r 0x10 dev:/dev/i2c-5 | grep Brightness | cut -d/ -f2)
next=$((curr + delta))

/usr/bin/ddccontrol -r 0x10 -w $next dev:/dev/i2c-5


