#! /bin/bash

set -eu

adb exec-out screencap -p > /tmp/android.png
convert -resize 25% /tmp/android.png /tmp/android-small.png
ksnip /tmp/android-small.png
