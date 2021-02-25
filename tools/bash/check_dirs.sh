#! /bin/bash

set -eu

# Check (possibly) colon-separated list of directories
# Usage: ./check_dirs.sh 'PATH' "$PATH"
echo "Checking: '$1'"

IFS=':'
for p in $2; do
    if [[ -d "$p" ]]; then
        exeCount=$(find "$p" -maxdepth 1 -executable -type f | wc -l)
        printf ' %4d %s\n' "$exeCount" "$p"
    else
        echo "   -- $p"
    fi
done
