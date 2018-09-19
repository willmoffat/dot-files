#! /bin/bash

set -eu

hostToTest=${1:-mjr}

for t in $(seq 1 10) ; do
	xterm -title "${hostToTest}${t}" -e ssh $hostToTest bin/to &
done

