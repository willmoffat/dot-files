#!/bin/bash

set -u

cd $(dirname $0)
# Set EMAIL and check_all function.
source webmonitor.private.sh

DUMP_DIR="$HOME/.webmonitor"

function email_log {
  LABEL=$1
  LOG=$2
  cat $2 | mail -s "[webmonitor] $LABEL" $EMAIL
}

function check {
  LABEL=$1
  URL=$2
  DIR="$DUMP_DIR/$LABEL"

  echo "Check $LABEL $URL"

  mkdir -p $DIR
  cd $DIR
  date

  wget --output-document=index.0.html "$URL" 2> wget.err
  if [ $? -ne 0 ]
  then
      email_log "wget fail $LABEL" wget.err
      return
  fi

  rm index.2.html
  mv index.1.html index.2.html
  mv index.0.html index.1.html

  diff index.1.html index.2.html > diff.txt
  if [ $? -ne 0 ]
  then
      echo DIFF
      email_log $LABEL diff.txt
      return
  fi
  echo NO DIFF
}

echo "Webmonitor running..."

while [ 1 ]
do
  check_all  # private function that calls 'check LABEL URL'
  sleep 43200 # half day
done

# 86400 seconds per day
