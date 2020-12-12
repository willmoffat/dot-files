#! /bin/bash

# Connect to both WiFi networks on my home router and monitor traffic.

sudo ls  # To trigger password entry if necessary
(ssh router2 /usr/sbin/tcpdump -i wlan0 -U -s0 -w - | sudo wireshark -k -i - &) # 2.4 GHz
(ssh router2 /usr/sbin/tcpdump -i wlan1 -U -s0 -w - | sudo wireshark -k -i - &) # 5 GHz
