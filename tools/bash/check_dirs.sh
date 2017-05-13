#! /bin/bash

set -eu

# Check (possibly) colon-separated list of directories
# Usage: ./check_dirs.sh 'PATH' "$PATH"
echo "Checking:  $1"

IFS=':'
for p in $2; do
    if [[ -d "$p" ]]; then
        echo "OK: $p"
    else
        echo "Fail: $p"
    fi
done
