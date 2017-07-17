#! /bin/bash

# Look for non-ASCII chars in files.

set -eu

find . -type f -exec grep -Iq . {} \; -and -print0 | \
    xargs -0 perl -ne 'print if /[^[:ascii:]]/'
