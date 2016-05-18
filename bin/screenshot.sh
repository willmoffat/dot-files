#! /bin/bash

set -eu

FILE=~/Pictures/screenshot-$(/bin/date +%Y%m%d-%H:%M:%S).png

import "$FILE"
thunar "$FILE" || i3-nagbar -t warning -m "$FILE"
