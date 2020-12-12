#! /bin/bash

# Connect to both WiFi networks on my home router and monitor traffic.

ssh_tcpdump() {
  iface=$1

  # -i  interface
  # -U  packet-buffered
  # -s0 default snaplen of 262K
  # -w  file
  # -   stdout

  # shellcheck disable=SC2029
  ssh router2 /usr/sbin/tcpdump -i "$iface" -U -s0 -w -
}

run_wireshark() {
  title=$1
  # -k    start capturing immediately
  # -i -  interface is stdin
  wireshark -o "gui.window_title:$title" -k -i -
}

dump() {
  iface=$1
  title=$2
  ssh_tcpdump "$iface" | run_wireshark "$iface - $title"
}

dump 'wlan0' '2.4 GHz' &
dump 'wlan1' '5.0 GHz' &

# Ctrl-C to exit (and kill tcpdump processes on router)
wait
