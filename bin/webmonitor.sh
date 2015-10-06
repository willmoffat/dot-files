#!/bin/bash

set -u

cd $(dirname $0)
# Set EMAIL and check_all function.
source webmonitor.private.sh

DUMP_DIR="$HOME/.webmonitor"

function check {
  LABEL=$1		
  URL=$2
  DIR="$DUMP_DIR/$LABEL"
  mkdir -p $DIR
  cd $DIR
  date
  wget $URL
  diff index.html index.html.old > diff.txt

  if [ $? -ne 0 ]
  then
      echo DIFF
      cat diff.txt | mail -s "[webmonitor] $LABEL" $EMAIL
  else
      echo NO DIFF
  fi

  rm index.html.old
  mv index.html index.html.old
}

echo "Webmonitor running..."

while [ 1 ]
do
  check_all  # private function that calls 'check LABEL URL'
  sleep 43200 # half day
done

# 86400 seconds per day




