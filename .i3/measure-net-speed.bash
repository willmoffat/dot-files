#!/bin/bash

set -eu

# http://code.stapelberg.de/git/i3status/tree/contrib/measure-net-speed.bash

# path to store the old results in
path="/dev/shm/measure-net-speed"

# adapters:
ETH="enxc8d719627aa9"
WLAN="wlp2s0"

# grabbing data for each adapter.
eth_stat=/sys/class/net/$ETH/statistics
wlan_stat=/sys/class/net/$WLAN/statistics

eth0_rx=0
eth0_tx=0
wlan0_rx=0
wlan0_tx=0

if [ -r $eth_stat ]; then
    read eth0_rx < "$eth_stat/rx_bytes"
    read eth0_tx < "$eth_stat/tx_bytes"
fi
if [ -r $wlan_stat ]; then
    read wlan0_rx < "$wlan_stat/rx_bytes"
    read wlan0_tx < "$wlan_stat/tx_bytes"
fi

# get time and sum of rx/tx for combined display
time=$(date +%s)
rx=$(( $eth0_rx + $wlan0_rx ))
tx=$(( $eth0_tx + $wlan0_tx ))

# write current data if file does not exist. Do not exit, this will cause
# problems if this file is sourced instead of executed as another process.
if ! [[ -f "${path}" ]]; then
  echo "${time} ${rx} ${tx}" > "${path}"
  chmod 0666 "${path}"
fi

# read previous state and update data storage
read old < "${path}"
echo "${time} ${rx} ${tx}" > "${path}"

# parse old data and calc time passed
old=(${old//;/ })
time_diff=$(( $time - ${old[0]} ))

# sanity check: has a positive amount of time passed
if [[ "${time_diff}" -gt 0 ]]; then
  # calc bytes transferred, and their rate in byte/s
  rx_diff=$(( $rx - ${old[1]} ))
  tx_diff=$(( $tx - ${old[2]} ))
  rx_rate=$(( $rx_diff / $time_diff ))
  tx_rate=$(( $tx_diff / $time_diff ))

  # shift by 10 bytes to get KiB/s. If the value is larger than
  # 1024^2 = 1048576, then display MiB/s instead (simply cut off
  # the last two digits of KiB/s). Since the values only give an
  # rough estimate anyway, this improper rounding is negligible.

  # incoming
  rx_kib=$(( $rx_rate >> 10 ))
  if [[ "$rx_rate" -gt 1048576 ]]; then
    echo -n "${rx_kib:0:-3}.${rx_kib: -3:-2} M↓"
  else
    echo -n "${rx_kib} K↓"
  fi

  echo -n "  "

  # outgoing
  tx_kib=$(( $tx_rate >> 10 ))
  if [[ "$tx_rate" -gt 1048576 ]]; then
    echo -n "${tx_kib:0:-3}.${tx_kib: -3:-2} M↑"
  else
    echo -n "${tx_kib} K↑"
  fi

  # RAM usage:
  mem=$(awk '/MemTotal/ {memtotal=$2}; /MemAvailable/ {memavail=$2}; END { \
          printf("%.0f", (100- (memavail / memtotal * 100))) }' \
          /proc/meminfo)
  echo -n " 🐏$mem% "
else
  echo -n " ? "
fi
