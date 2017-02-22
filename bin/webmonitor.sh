#!/bin/bash

# To install in user crontab:
# crontab -e
# Confirm with:
# crontab -l
#   m h  dom mon dow   command
#   30 6,12,20 * * *     /home/wdm/bin/webmonitor.sh

set -u

cd "$(dirname "$0")"
# Set EMAIL and check_all function.
source webmonitor.private.sh

DUMP_DIR="/var/log/webmonitor"

function email_log {
  LABEL=$1
  LOG=$2
  mail -aFrom:will@example.com -s "[webmonitor] $LABEL" "$EMAIL" < "$LOG"
}

function check {
  LABEL=$1
  URL=$2

  echo "Check $LABEL $URL"

  DIR="$DUMP_DIR/$LABEL"

  DUMP0=index.0.txt # Current dump - may fail.
  DUMP1=index.1.txt # Previous successful dump
  DUMP2=index.2.txt # Prevoius, previous. #TODO(wdm) Needed?

  DUMP_LOG=dump.err
  DIFF_LOG=diff.txt

  mkdir -p "$DIR"
  cd "$DIR"
  date

  # wget --output-document=$DUMP0 "$URL" 2>$DUMP_LOG
  lynx -dump -nolist -stderr "$URL" 1>$DUMP0 2>$DUMP_LOG
  if [ $? -ne 0 ]
  then
      email_log "dump fail $LABEL" $DUMP_LOG
      return
  fi

  rm $DUMP2
  mv $DUMP1 $DUMP2
  mv $DUMP0 $DUMP1

  diff $DUMP1 $DUMP2 > $DIFF_LOG
  if [ $? -ne 0 ]
  then
      echo DIFF
      email_log "$LABEL" "$DIFF_LOG"
      return
  fi
  echo NO DIFF
}

echo "Webmonitor running..."

check_all  # private function that calls 'check LABEL URL'
